<?php
/*
 * Copyright (C) 2016 E-ComProcessing™
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
 * @author      E-ComProcessing
 * @copyright   2016 E-ComProcessing™
 * @license     http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 */
?>

<?php echo $header; ?><?php echo $column_left; ?>

<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <span class="form-loading">
                    <i class="fa fa-spinner fa-spin fa-lg"></i>
                </span>
                <button type="button" id="<?php echo $module_name;?>_submit" data-form="form-ecomprocessing_direct" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
            <h1><?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div class="container-fluid module-controls-container">
        <div class="alert alert-notification alert-dismissible">
            <i class="fa fa-info-circle"></i>
            <span class="alert-text"></span>
            <button type="button" class="close" data-hide="alert-notification">&times;</button>
        </div>
        <?php if ($error_warning) { ?>
        <div class="alert alert-warning"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <?php } ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="fa fa-pencil"></i>&nbsp;<?php echo $text_edit; ?>
                </h3>
            </div>
            <div class="panel-body">
                <form data-action="<?php echo $action; ?>" data-method="post" enctype="multipart/form-data" id="form-ecomprocessing_direct" class="form-horizontal">
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="input-account">
                            <?php echo $entry_username; ?>
                        </label>
                        <div class="col-sm-10">
                            <input type="text" id="<?php echo $module_name;?>_username" name="<?php echo $module_name;?>_username" value="<?php echo $ecomprocessing_direct_username; ?>" placeholder="<?php echo $entry_username; ?>" id="input-account" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="input-secret">
                            <?php echo $entry_password; ?>
                        </label>
                        <div class="col-sm-10">
                            <input type="text" id="<?php echo $module_name;?>_password" name="<?php echo $module_name;?>_password" value="<?php echo $ecomprocessing_direct_password; ?>" placeholder="<?php echo $entry_password; ?>" id="input-secret" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="input-secret">
                            <?php echo $entry_token; ?>
                        </label>
                        <div class="col-sm-10">
                            <input type="text" id="<?php echo $module_name;?>_token" name="<?php echo $module_name;?>_token" value="<?php echo $ecomprocessing_direct_token; ?>" placeholder="<?php echo $entry_token; ?>" id="input-secret" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            <span data-toggle="tooltip" title="<?php echo $help_sandbox; ?>">
                                <?php echo $entry_sandbox; ?>
                        </label>
                        <div class="col-sm-10 bootstrap-checkbox-holder">
                            <input type="hidden" name="ecomprocessing_direct_sandbox"
                                   value="<?php echo $ecomprocessing_direct_sandbox;?>" />
                            <input type="checkbox" class="bootstrap-checkbox"
                            <?php if ($ecomprocessing_direct_sandbox) { ?>
                            checked="checked"
                            <?php } ?>
                            />
                        </div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="input-status">
                            <?php echo $entry_transaction_type; ?>
                        </label>
                        <div class="col-sm-10">
                            <select id="<?php echo $module_name;?>_transaction_type" name="<?php echo $module_name;?>_transaction_type" class="form-control">
                                <?php foreach ($transaction_types as $transaction_type) { ?>
                                <?php if ($transaction_type['id'] == $ecomprocessing_direct_transaction_type) { ?>
                                <option value="<?php echo $transaction_type['id']; ?>" selected="selected"><?php echo $transaction_type['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $transaction_type['id']; ?>"><?php echo $transaction_type['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            <span data-toggle="tooltip" title="<?php echo $help_supports_partial_capture; ?>">
                                <?php echo $entry_supports_partial_capture;?>
                            </span>
                        </label>
                        <div class="col-sm-10 bootstrap-checkbox-holder">
                            <input type="hidden" name="ecomprocessing_direct_supports_partial_capture"
                                   value="<?php echo $ecomprocessing_direct_supports_partial_capture;?>" />
                            <input type="checkbox" class="bootstrap-checkbox"
                            <?php if ($ecomprocessing_direct_supports_partial_capture) { ?>
                            checked="checked"
                            <?php } ?>
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            <span data-toggle="tooltip" title="<?php echo $help_supports_partial_refund; ?>">
                                <?php echo $entry_supports_partial_refund;?>
                            </span>
                        </label>
                        <div class="col-sm-10 bootstrap-checkbox-holder">
                            <input type="hidden" name="ecomprocessing_direct_supports_partial_refund"
                                   value="<?php echo $ecomprocessing_direct_supports_partial_refund;?>" />
                            <input type="checkbox" class="bootstrap-checkbox"
                            <?php if ($ecomprocessing_direct_supports_partial_refund) { ?>
                            checked="checked"
                            <?php } ?>
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            <span data-toggle="tooltip" title="<?php echo $help_supports_void; ?>">
                                <?php echo $entry_supports_void;?>
                            </span>
                        </label>
                        <div class="col-sm-10 bootstrap-checkbox-holder">
                            <input type="hidden" name="ecomprocessing_direct_supports_void"
                                   value="<?php echo $ecomprocessing_direct_supports_void; ?>" />
                            <input type="checkbox" class="bootstrap-checkbox"
                            <?php if ($ecomprocessing_direct_supports_void) { ?>
                            checked="checked"
                            <?php } ?>
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status">
                            <span data-toggle="tooltip" title="<?php echo $help_order_status; ?>">
                                <?php echo $entry_order_status; ?>
                            </span>
                        </label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_direct_order_status_id" id="input-order-status" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                <?php if ($order_status['order_status_id'] == $ecomprocessing_direct_order_status_id) { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status">
                            <span data-toggle="tooltip" title="<?php echo $help_async_order_status; ?>">
                                <?php echo $entry_async_order_status; ?>
                            </span>
                        </label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_direct_async_order_status_id" id="input-order-status" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                <?php if ($order_status['order_status_id'] == $ecomprocessing_direct_async_order_status_id) { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status">
                            <span data-toggle="tooltip" title="<?php echo $help_failure_order_status; ?>">
                                <?php echo $entry_failure_order_status; ?>
                            </span>
                        </label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_direct_failure_order_status_id" id="input-order-status" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                <?php if ($order_status['order_status_id'] == $ecomprocessing_direct_failure_order_status_id) { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-total">
                            <span data-toggle="tooltip" title="<?php echo $help_total; ?>">
                                <?php echo $entry_total; ?>
                            </span>
                        </label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_direct_total" value="<?php echo $ecomprocessing_direct_total; ?>" placeholder="<?php echo $entry_total; ?>" id="input-total" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-geo-zone">
                            <?php echo $entry_geo_zone; ?>
                        </label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_direct_geo_zone_id" id="input-geo-zone" class="form-control">
                                <option value="0"><?php echo $text_all_zones; ?></option>
                                <?php foreach ($geo_zones as $geo_zone) { ?>
                                <?php if ($geo_zone['geo_zone_id'] == $ecomprocessing_direct_geo_zone_id) { ?>
                                <option value="<?php echo $geo_zone['geo_zone_id']; ?>" selected="selected"><?php echo $geo_zone['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $geo_zone['geo_zone_id']; ?>"><?php echo $geo_zone['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status">
                            <?php echo $entry_status; ?>
                        </label>
                        <div class="col-sm-10 bootstrap-checkbox-holder">
                            <input type="hidden" name="ecomprocessing_direct_status"
                                   value="<?php echo $ecomprocessing_direct_status;?>" />
                            <input type="checkbox" class="bootstrap-checkbox"
                            <?php if ($ecomprocessing_direct_status) { ?>
                            checked="checked"
                            <?php } ?>
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status">
                            <?php echo $entry_debug; ?>
                        </label>
                        <div class="col-sm-10 bootstrap-checkbox-holder">
                            <input type="hidden" name="ecomprocessing_direct_debug"
                                   value="<?php echo $ecomprocessing_direct_debug;?>" />
                            <input type="checkbox" class="bootstrap-checkbox"
                            <?php if ($ecomprocessing_direct_debug) { ?>
                            checked="checked"
                            <?php } ?>
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-sort-order">
                            <?php echo $entry_sort_order; ?>
                        </label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_direct_sort_order" value="<?php echo $ecomprocessing_direct_sort_order; ?>" placeholder="<?php echo $entry_sort_order; ?>" id="input-sort-order" class="form-control" />
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?php echo $footer; ?>

<script type="text/javascript">

    function createBootstrapValidator(submitFormSelector) {
        var submitForm = $(submitFormSelector);

        submitForm.bootstrapValidator({
                    fields: {
                        username: {
                            selector: '#<?php echo $module_name;?>_username',
                            validators: {
                                notEmpty: {
                                    message: '<?php echo $error_username;?>'
                                }
                            }
                        },
                        password: {
                            selector: '#<?php echo $module_name;?>_password',
                            validators: {
                                notEmpty: {
                                    message: '<?php echo $error_password;?>'
                                }
                            }
                        },
                        token: {
                            selector: '#<?php echo $module_name;?>_token',
                            validators: {
                                notEmpty: {
                                    message: '<?php echo $error_token;?>'
                                }
                            }
                        },
                        transactionType: {
                            selector: '#<?php echo $module_name;?>_transaction_type',
                            validators: {
                                notEmpty: {
                                    message: '<?php echo $error_transaction_type;?>'
                                }
                            }
                        }
                    }
                })
                .on('success.form.bv', function(e) {
                    e.preventDefault(); // Prevent the form from submitting
                });

        return true;
    }

    function destroyBootstrapValidator(submitFormSelector) {
        var submitForm = $(submitFormSelector);
        submitForm.bootstrapValidator('destroy');
    }

    function hideAlertNotification() {
        var $alertNotificationHolder = $('.module-controls-container').find('.alert-notification');
        $alertNotificationHolder.slideUp();
    }

    function displayAlertNotification(type, messageText) {
        var $alertNotificationHolder = $('.module-controls-container').find('.alert-notification');
        var alertNotificationClass = 'alert-' + type;
        var notificationTypes = [
            'info',
            'success',
            'warning',
            'danger'
        ];

        $alertNotificationHolder.find('.alert-text').html(messageText);

        $.each(notificationTypes, function(index, key) {
            $alertNotificationHolder.removeClass('alert-' + key);
        });

        $alertNotificationHolder.addClass(alertNotificationClass).slideDown();
    }

    $(function() {

        destroyBootstrapValidator('#form-ecomprocessing_direct');
        createBootstrapValidator('#form-ecomprocessing_direct');

        $("[data-hide]").on("click", function(){
            $("." + $(this).attr("data-hide")).slideUp();
        });

        $('#<?php echo $module_name;?>_submit').click(function() {
            var $submitForm = $('#' + $(this).attr('data-form'));
            $submitForm.submit();
        });

        $('#form-ecomprocessing_direct').submit(function() {
            var $form = $(this);

            hideAlertNotification();

            $.ajax({
                url:    $form.attr('data-action'),
                type:   $form.attr('data-method'),
                data:   $form.serialize(),
                beforeSend: function () {
                    $('#<?php echo $module_name;?>_submit').attr('disabled', 'disabled');
                    $('#<?php echo $module_name;?>_submit').parent().find('.form-loading').fadeIn('fast');
                },
                complete: function() {
                    $('#<?php echo $module_name;?>_submit').parent().find('.form-loading').fadeOut('fast');
                    $('#<?php echo $module_name;?>_submit').removeAttr('disabled');
                },
                success: function (data) {
                    if (data.success == 1)
                        displayAlertNotification('success', data.text);
                    else if (data.text !== undefined && data.text.length > 0) {
                        displayAlertNotification('danger', data.text);
                    }
                    else {
                        displayAlertNotification('danger', '<?php echo $text_failed;?>');
                    }
                },
                error: function(xhr) {
                    displayAlertNotification('danger', '<?php echo $text_failed;?>');
                }
            });

            // prevent re-submitting
            return false;
        });

        $('input.bootstrap-checkbox').checkboxpicker({
            html: false,
            offLabel: '<?php echo $text_no;?>',
            onLabel: '<?php echo $text_yes;?>',
            style: 'btn-group-sm'
        });

        $('input.bootstrap-checkbox').change(function() {
            var isChecked = $(this).prop('checked');
            $(this).parent().find('input[type="hidden"]').val((isChecked ? 1 : 0));
        });

    });

</script>