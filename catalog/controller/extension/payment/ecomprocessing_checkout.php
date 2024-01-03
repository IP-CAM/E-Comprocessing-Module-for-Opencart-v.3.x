<?php
/*
 * Copyright (C) 2018 E-Comprocessing Ltd.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * @author	  E-Comprocessing
 * @copyright   2018 E-Comprocessing Ltd.
 * @license	 http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 */

use Genesis\API\Constants\Transaction\Parameters\Threeds\V2\CardHolderAccount\RegistrationIndicators;
use Genesis\API\Constants\Transaction\Parameters\Threeds\V2\MerchantRisk\DeliveryTimeframes;
use Genesis\API\Constants\Transaction\Parameters\Threeds\V2\Purchase\Categories;

if (!class_exists('ControllerExtensionPaymentEcomprocessingBase')) {
	require_once DIR_APPLICATION . "controller/extension/payment/ecomprocessing/base_controller.php";
}

/**
 * Front-end controller for the "ecomprocessing Checkout" module
 *
 * @package EcomprocessingCheckout
 *
 * @SuppressWarnings(PHPMD.LongVariable)
 */
class ControllerExtensionPaymentEcomprocessingCheckout extends ControllerExtensionPaymentEcomprocessingBase
{

	/**
	 * Module Name
	 *
	 * @var string
	 */
	protected $module_name = 'ecomprocessing_checkout';

	/**
	 * Init
	 *
	 * @param $registry
	 */
	public function __construct($registry)
	{
		parent::__construct($registry);
	}

	/**
	 * Entry-point
	 *
	 * @return mixed
	 */
	public function index()
	{
		$this->load->language('extension/payment/ecomprocessing_checkout');
		$this->load->model('extension/payment/ecomprocessing_checkout');

		if ($this->model_extension_payment_ecomprocessing_checkout->isCartContentMixed()) {
			$template = 'ecomprocessing_disabled.tpl';
			$data = $this->prepareViewDataMixedCart();

		} else {
			$template = 'ecomprocessing_checkout.tpl';

			$data = $this->prepareViewData();
		}

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/payment/' . $template)) {
			return $this->load->view(
				$this->config->get('config_template') . '/template/payment/' . $template,
				$data
			);
		} else {
			return $this->load->view('payment/' . $template, $data);
		}
	}

	/**
	 * Prepares data for the view
	 *
	 * @return array
	 */
	public function prepareViewData()
	{
		$data = array(
			'text_title'	 => $this->language->get('text_title'),
			'text_loading'   => $this->language->get('text_loading'),

			'button_confirm' => $this->language->get('button_confirm'),
			'button_target'  => $this->url->link('extension/payment/ecomprocessing_checkout/send', '', 'SSL'),

			'scripts'		 => $this->document->getScripts()
		);

		return $data;
	}

	/**
	 * Prepares data for the view when cart content is mixed
	 *
	 * @return array
	 */
	public function prepareViewDataMixedCart()
	{
		$data = array(
			'text_loading'					  => $this->language->get('text_loading'),
			'text_payment_mixed_cart_content' => $this->language->get('text_payment_mixed_cart_content'),
			'button_shopping_cart'			  => $this->language->get('button_shopping_cart'),
			'button_target'					  => $this->url->link('checkout/cart')
		);

		return $data;
	}

	/**
	 * Process order confirmation
	 *
	 * @return void
	 *
	 * @SuppressWarnings(PHPMD.LongVariable)
	 */
	public function send()
	{
		$this->load->model('checkout/order');
		$this->load->model('account/order');
		$this->load->model('account/customer');
		$this->load->model('extension/payment/ecomprocessing_checkout');

		$this->load->language('extension/payment/ecomprocessing_checkout');

		try {
			$order_info         = $this->model_checkout_order->getOrder($this->session->data['order_id']);
			$product_order_info = $this->model_extension_payment_ecomprocessing_checkout
				->getDbOrderProducts($this->session->data['order_id']);
			$order_totals       = $this->model_extension_payment_ecomprocessing_checkout
				->getOrderTotals($this->session->data['order_id']);
			$product_info       = $this->model_extension_payment_ecomprocessing_checkout->getProductsInfo(
				array_map(
					function ($value) {
						return $value['product_id'];
					},
					$product_order_info
				)
			);

			$model_account_order             = $this->model_account_order;
			$model_account_customer          = $this->model_account_customer;

			$customer_orders                 = EcomprocessingThreedsHelper::getCustomerOrders(
				$this->db,
				$this->getCustomerId(),
				(int)$this->config->get('config_store_id'),
				(int)$this->config->get('config_language_id'),
				$this->module_name
			);

			$is_guest                        = isset($this->session->data['guest']);
			$has_physical_products           = EcomprocessingThreedsHelper::hasPhysicalProduct($product_info);
			$threeds_challenge_indicator     = $this->config->get('ecomprocessing_checkout_threeds_challenge_indicator');

			$threeds_purchase_category       = EcomprocessingThreedsHelper::hasPhysicalProduct($product_info) ? Categories::GOODS : Categories::SERVICE;
			$threeds_delivery_timeframe      = ($has_physical_products) ? DeliveryTimeframes::ANOTHER_DAY : DeliveryTimeframes::ELECTRONICS;
			$threeds_shipping_indicator      = EcomprocessingThreedsHelper::getShippingIndicator($has_physical_products, $order_info, $is_guest);
			$threeds_reorder_items_indicator = EcomprocessingThreedsHelper::getReorderItemsIndicator(
				$model_account_order,
				$is_guest, $product_info,
				$customer_orders
			);
			$threeds_registration_indicator  = RegistrationIndicators::GUEST_CHECKOUT;

			if (!$is_guest) {
				$threeds_registration_date                = EcomprocessingThreedsHelper::findFirstCustomerOrderDate($customer_orders);
				$threeds_registration_indicator           = EcomprocessingThreedsHelper::getRegistrationIndicator($threeds_registration_date);
				$threeds_creation_date                    = EcomprocessingThreedsHelper::getCreationDate($model_account_customer, $order_info['customer_id']);

				$shipping_address_date_first_used         = EcomprocessingThreedsHelper::findShippingAddressDateFirstUsed(
					$model_account_order,
					$order_info,
					$customer_orders
				);
				$threads_shipping_address_date_first_used = $shipping_address_date_first_used;
				$threeds_shipping_address_usage_indicator = EcomprocessingThreedsHelper::getShippingAddressUsageIndicator($shipping_address_date_first_used);

				$orders_for_a_period                      = EcomprocessingThreedsHelper::findNumberOfOrdersForaPeriod(
					$model_account_order,
					$customer_orders
				);
				$transactions_activity_last_24_hours      = $orders_for_a_period['last_24h'];
				$transactions_activity_previous_year      = $orders_for_a_period['last_year'];
				$purchases_count_last_6_months            = $orders_for_a_period['last_6m'];
			}

			$data = array(
				'transaction_id'	 => $this->model_extension_payment_ecomprocessing_checkout->genTransactionId(self::PLATFORM_TRANSACTION_PREFIX),

				'remote_address'	 => $this->request->server['REMOTE_ADDR'],

				'usage'			     => $this->model_extension_payment_ecomprocessing_checkout->getUsage(),
				'description'		 => $this->model_extension_payment_ecomprocessing_checkout->getOrderProducts(
					$this->session->data['order_id']
				),

				'language'		     => $this->model_extension_payment_ecomprocessing_checkout->getLanguage(),

				'currency'		     => $this->model_extension_payment_ecomprocessing_checkout->getCurrencyCode(),
				'amount'			 => (float)$order_info['total'],

				'customer_email'	 => $order_info['email'],
				'customer_phone'	 => $order_info['telephone'],

				'notification_url'   => $this->url->link('extension/payment/ecomprocessing_checkout/callback', '', 'SSL'),
				'return_success_url' => $this->url->link('extension/payment/ecomprocessing_checkout/success', '', 'SSL'),
				'return_failure_url' => $this->url->link('extension/payment/ecomprocessing_checkout/failure', '', 'SSL'),
				'return_cancel_url'  => $this->url->link('extension/payment/ecomprocessing_checkout/cancel', '', 'SSL'),

				'billing'			 => array(
					'first_name'     => $order_info['payment_firstname'],
					'last_name'      => $order_info['payment_lastname'],
					'address1'       => $order_info['payment_address_1'],
					'address2'       => $order_info['payment_address_2'],
					'zip'		     => $order_info['payment_postcode'],
					'city'	         => $order_info['payment_city'],
					'state'	         => $order_info['payment_zone_code'],
					'country'	     => $order_info['payment_iso_code_2'],
				),

				'shipping'		     => array(
					'first_name'     => $order_info['shipping_firstname'],
					'last_name'      => $order_info['shipping_lastname'],
					'address1'       => $order_info['shipping_address_1'],
					'address2'       => $order_info['shipping_address_2'],
					'zip'		     => $order_info['shipping_postcode'],
					'city'	         => $order_info['shipping_city'],
					'state'	         => $order_info['shipping_zone_code'],
					'country'	     => $order_info['shipping_iso_code_2'],
				),

				'additional'             => array(
					'user_id'            => $this->model_extension_payment_ecomprocessing_checkout->getCurrentUserId(),
					'user_hash'          => $this->getCurrentUserIdHash(),
					'product_order_info' => $product_order_info,
					'product_info'       => $product_info,
					'order_totals'       => $order_totals
				),

				'is_guest'                        => $is_guest,
				'threeds_challenge_indicator'     => $threeds_challenge_indicator,
				'threeds_purchase_category'       => $threeds_purchase_category,
				'threeds_delivery_timeframe'      => $threeds_delivery_timeframe,
				'threeds_shipping_indicator'      => $threeds_shipping_indicator,
				'threeds_reorder_items_indicator' => $threeds_reorder_items_indicator,
				'threeds_registration_indicator'  => $threeds_registration_indicator,
				'sca_exemption_value'             => $this->config->get('ecomprocessing_checkout_sca_exemption'),
				'sca_exemption_amount'            => $this->config->get('ecomprocessing_checkout_sca_exemption_amount'),
			);
			if (!$is_guest) {
				$data['threeds_creation_date']                    = $threeds_creation_date;
				$data['threads_shipping_address_date_first_used'] = $threads_shipping_address_date_first_used;
				$data['threeds_shipping_address_usage_indicator'] = $threeds_shipping_address_usage_indicator;
				$data['transactions_activity_last_24_hours']      = $transactions_activity_last_24_hours;
				$data['transactions_activity_previous_year']      = $transactions_activity_previous_year;
				$data['purchases_count_last_6_months']            = $purchases_count_last_6_months;
			}

			$transaction = $this->model_extension_payment_ecomprocessing_checkout->create($data);

			if (isset($transaction->unique_id)) {
				$timestamp = ($transaction->timestamp instanceof \DateTime) ? $transaction->timestamp->format('c') : $transaction->timestamp;

				$data = array(
					'type'			    => 'checkout',
					'reference_id'	    => '0',
					'order_id'		    => $order_info['order_id'],
					'unique_id'		    => $transaction->unique_id,
					'status'			=> $transaction->status,
					'amount'			=> $transaction->amount,
					'currency'		    => $transaction->currency,
					'message'		    => isset($transaction->message) ? $transaction->message : '',
					'technical_message' => isset($transaction->technical_message) ? $transaction->technical_message : '',
					'timestamp'		    => $timestamp,
				);

				$this->model_extension_payment_ecomprocessing_checkout->populateTransaction($data);

				$this->model_checkout_order->addOrderHistory(
					$this->session->data['order_id'],
					$this->config->get('ecomprocessing_checkout_order_status_id'),
					$this->language->get('text_payment_status_initiated'),
					true
				);

				if ($this->model_extension_payment_ecomprocessing_checkout->isRecurringOrder()) {
					$this->addOrderRecurring(null); // "checkout" transaction type
					$this->model_extension_payment_ecomprocessing_checkout->populateRecurringTransaction($data);
					$this->model_extension_payment_ecomprocessing_checkout->updateOrderRecurring($data);
				}

				$json = array(
					'redirect' => $transaction->redirect_url
				);
			} else {
				$json = array(
					'error' => $this->language->get('text_payment_system_error')
				);
			}
		} catch (\Exception $exception) {
			$json = array(
				'error' => ($exception->getMessage()) ? $exception->getMessage() : $this->language->get('text_payment_system_error')
			);

			$this->model_extension_payment_ecomprocessing_checkout->logEx($exception);
		}

		$this->response->addHeader('Content-Type: application/json');

		$this->response->setOutput(
			json_encode($json)
		);
	}

	/**
	 * Process Gateway Notification
	 *
	 * @return void
	 */
	public function callback()
	{
		$this->load->model('checkout/order');
		$this->load->model('extension/payment/ecomprocessing_checkout');

		$this->load->language('extension/payment/ecomprocessing_checkout');

		try {
			$this->model_extension_payment_ecomprocessing_checkout->bootstrap();

			$notification = new \Genesis\API\Notification(
				$this->request->post
			);

			if ($notification->isAuthentic()) {
				$notification->initReconciliation();

				$wpf_reconcile = $notification->getReconciliationObject();

				$timestamp = ($wpf_reconcile->timestamp instanceof \DateTime) ? $wpf_reconcile->timestamp->format('c') : $wpf_reconcile->timestamp;

				$data = array(
					'unique_id' => $wpf_reconcile->unique_id,
					'status'	=> $wpf_reconcile->status,
					'currency'  => $wpf_reconcile->currency,
					'amount'	=> $wpf_reconcile->amount,
					'timestamp' => $timestamp,
				);

				$this->model_extension_payment_ecomprocessing_checkout->populateTransaction($data);

				$transaction = $this->model_extension_payment_ecomprocessing_checkout->getTransactionById(
					$wpf_reconcile->unique_id
				);

				$reference = null;

				if (isset($transaction['order_id']) && abs((int)$transaction['order_id']) > 0) {
					if (isset($wpf_reconcile->payment_transaction)) {

						$payment_transaction = $this->getPaymentTransaction($wpf_reconcile);

						$timestamp = ($payment_transaction->timestamp instanceof \DateTime) ? $payment_transaction->timestamp->format('c') : $payment_transaction->timestamp;

						$data = array(
							'order_id'		    => $transaction['order_id'],
							'reference_id'	    => $wpf_reconcile->unique_id,
							'unique_id'		    => $payment_transaction->unique_id,
							'type'			    => $payment_transaction->transaction_type,
							'mode'			    => $payment_transaction->mode,
							'status'			=> $payment_transaction->status,
							'currency'		    => $payment_transaction->currency,
							'amount'			=> $payment_transaction->amount,
							'timestamp'		    => $timestamp,
							'terminal_token'	=> isset($payment_transaction->terminal_token) ? $payment_transaction->terminal_token : '',
							'message'		    => isset($payment_transaction->message) ? $payment_transaction->message : '',
							'technical_message' => isset($payment_transaction->technical_message) ? $payment_transaction->technical_message : '',
						);

						$this->model_extension_payment_ecomprocessing_checkout->populateTransaction($data);

						if ($this->model_extension_payment_ecomprocessing_checkout->isInitialRecurringTransaction($payment_transaction->transaction_type))
						{
							$reference = $payment_transaction->unique_id;
						}
					}

					switch ($wpf_reconcile->status) {
						case \Genesis\API\Constants\Transaction\States::APPROVED:
							$this->model_checkout_order->addOrderHistory(
								$transaction['order_id'],
								$this->config->get('ecomprocessing_checkout_order_status_id'),
								$this->language->get('text_payment_status_successful'),
								true
							);
							break;
						case \Genesis\API\Constants\Transaction\States::DECLINED:
						case \Genesis\API\Constants\Transaction\States::ERROR:
							$this->model_checkout_order->addOrderHistory(
								$transaction['order_id'],
								$this->config->get('ecomprocessing_checkout_order_failure_status_id'),
								$this->language->get('text_payment_status_unsuccessful'),
								true
							);
							break;
					}
				}

				if ($this->model_extension_payment_ecomprocessing_checkout->isRecurringOrder()) {
					$this->model_extension_payment_ecomprocessing_checkout->populateRecurringTransaction($data);
					$this->model_extension_payment_ecomprocessing_checkout->updateOrderRecurring($data, $reference);
				}

				$this->response->addHeader('Content-Type: text/xml');

				$this->response->setOutput(
					$notification->generateResponse()
				);
			}
		} catch (\Exception $exception) {
			$this->model_extension_payment_ecomprocessing_checkout->logEx($exception);
		}
	}

	/**
	 * Handle client redirection for successful status
	 *
	 * @return void
	 */
	public function success()
	{
		$this->response->redirect($this->url->link('checkout/success', '', 'SSL'));
	}

	/**
	 * Handle client redirection for failure status
	 *
	 * @return void
	 */
	public function failure()
	{
		$this->load->language('extension/payment/ecomprocessing_checkout');

		$this->session->data['error'] = $this->language->get('text_payment_failure');

		$this->response->redirect($this->url->link('checkout/checkout', '', 'SSL'));
	}

	/**
	 * Handle client redirection for cancelled status
	 *
	 * @return void
	 */
	public function cancel()
	{
		$this->load->language('extension/payment/ecomprocessing_checkout');

		$this->session->data['error'] = $this->language->get('text_payment_cancelled');

		$this->response->redirect($this->url->link('checkout/checkout', '', 'SSL'));
	}

	/**
	 * Redirect the user (to the login page), if they are not logged-in
	 */
	protected function isUserLoggedIn()
	{
		$is_callback = strpos((string)$this->request->get['route'], 'callback') !== false;

		if (!$this->customer->isLogged() && !$is_callback) {
			$this->response->redirect($this->url->link('account/login', '', 'SSL'));
		}
	}

	/**
	 * Adds recurring order
	 * @param string $payment_reference
	 */
	public function addOrderRecurring($payment_reference)
	{
		$recurring_products = $this->cart->getRecurringProducts();
		if (!empty($recurring_products)) {
			$this->load->model('extension/payment/ecomprocessing_checkout');
			$this->model_extension_payment_ecomprocessing_checkout->addOrderRecurring(
				$recurring_products,
				$payment_reference
			);
		}
	}

	/**
	 * Process the cron if the request is local
	 *
	 * @return void
	 */
	public function cron()
	{
		$this->load->model('extension/payment/ecomprocessing_checkout');
		$this->model_extension_payment_ecomprocessing_checkout->processRecurringOrders();
	}

	/**
	 * @return int
	 */
	public function getCustomerId()
	{
		if ($this->customer->isLogged()) {
			return $this->customer->getId();
		}

		return 0;
	}

	/**
	 * @param int $length
	 * @return string
	 */
	public function getCurrentUserIdHash($length = 30)
	{
		$user_id= $this->getCustomerId();

		$user_hash = ($user_id > 0) ? sha1($user_id) : $this->model_extension_payment_ecomprocessing_checkout->genTransactionId();

		return substr($user_hash, 0, $length);
	}

	/**
	* Get the payment transaction or the first element if we have reference transaction
	*
	* @param \StdClass $wpf_reconcile
	* @return \StdClass
	*/
	private function getPaymentTransaction($wpf_reconcile)
	{
		if (!isset($wpf_reconcile->payment_transaction)) {
			return $wpf_reconcile;
		}

		if ($wpf_reconcile->payment_transaction instanceof \ArrayObject) {
			return $wpf_reconcile->payment_transaction[0];
		}

		return $wpf_reconcile->payment_transaction;
	}
}
