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
 * @author      E-Comprocessing
 * @copyright   2018 E-Comprocessing Ltd.
 * @license     http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 */

if (!class_exists('ModelPaymentEComProcessingCheckout')) {
	require_once DIR_APPLICATION . 'model/payment/ecomprocessing_checkout.php';
}

/**
 * Front-end model for the "E-Comprocessing Checkout" module (3.0.x and above)
 *
 * @package EComProcessingCheckout
 */
class ModelExtensionPaymentEComProcessingCheckout extends ModelPaymentEComProcessingCheckout
{

}
