<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <button type="submit" form="form-ecomprocessing_checkout" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
            <h1><?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div class="container-fluid">
        <?php if ($error_warning) { ?>
        <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <?php } ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3>
            </div>
            <div class="panel-body">
                <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-ecomprocessing_checkout" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-account"><?php echo $entry_username; ?></label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_checkout_username" value="<?php echo $ecomprocessing_checkout_username; ?>" placeholder="<?php echo $entry_username; ?>" id="input-account" class="form-control" />
                            <?php if ($error_username) { ?>
                            <div class="text-danger"><?php echo $error_username; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-secret"><?php echo $entry_password; ?></span></label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_checkout_password" value="<?php echo $ecomprocessing_checkout_password; ?>" placeholder="<?php echo $entry_password; ?>" id="input-secret" class="form-control" />
                            <?php if ($error_password) { ?>
                            <div class="text-danger"><?php echo $error_password; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-secret"><?php echo $entry_token; ?></span></label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_checkout_token" value="<?php echo $ecomprocessing_checkout_token; ?>" placeholder="<?php echo $entry_token; ?>" id="input-secret" class="form-control" />
                            <?php if ($error_password) { ?>
                            <div class="text-danger"><?php echo $error_token; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label"><span data-toggle="tooltip" title="<?php echo $help_sandbox; ?>"><?php echo $entry_sandbox; ?></label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <?php if ($ecomprocessing_checkout_sandbox) { ?>
                                    <input type="radio" name="ecomprocessing_checkout_sandbox" value="1" checked="checked" />
                                    <?php echo $text_yes; ?>
                                <?php } else { ?>
                                    <input type="radio" name="ecomprocessing_checkout_sandbox" value="1" />
                                    <?php echo $text_yes; ?>
                                <?php } ?>
                            </label>
                            <label class="radio-inline">
                                <?php if (!$ecomprocessing_checkout_sandbox) { ?>
                                    <input type="radio" name="ecomprocessing_checkout_sandbox" value="0" checked="checked" />
                                    <?php echo $text_no; ?>
                                <?php } else { ?>
                                    <input type="radio" name="ecomprocessing_checkout_sandbox" value="0" />
                                    <?php echo $text_no; ?>
                                <?php } ?>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_transaction_type; ?></label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_checkout_transaction_type[]" id="input-order-status" class="form-control" multiple="multiple">
                                <?php foreach ($transaction_types as $transaction_type) { ?>
                                    <?php if (in_array($transaction_type['id'], $ecomprocessing_checkout_transaction_type)) { ?>
                                        <option value="<?php echo $transaction_type['id']; ?>" selected="selected"><?php echo $transaction_type['name']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $transaction_type['id']; ?>"><?php echo $transaction_type['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-total"><span data-toggle="tooltip" title="<?php echo $help_total; ?>"><?php echo $entry_total; ?></span></label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_checkout_total" value="<?php echo $ecomprocessing_checkout_total; ?>" placeholder="<?php echo $entry_total; ?>" id="input-total" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status"><span data-toggle="tooltip" title="<?php echo $help_order_status; ?>"><?php echo $entry_order_status; ?></label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_checkout_order_status_id" id="input-order-status" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $ecomprocessing_checkout_order_status_id) { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status"><span data-toggle="tooltip" title="<?php echo $help_order_status_failure; ?>"><?php echo $entry_order_status_async; ?></label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_checkout_order_failure_status_id" id="input-order-status" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $ecomprocessing_checkout_order_failure_status_id) { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-geo-zone"><?php echo $entry_geo_zone; ?></label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_checkout_geo_zone_id" id="input-geo-zone" class="form-control">
                                <option value="0"><?php echo $text_all_zones; ?></option>
                                    <?php foreach ($geo_zones as $geo_zone) { ?>
                                        <?php if ($geo_zone['geo_zone_id'] == $ecomprocessing_geo_zone_id) { ?>
                                            <option value="<?php echo $geo_zone['geo_zone_id']; ?>" selected="selected"><?php echo $geo_zone['name']; ?></option>
                                        <?php } else { ?>
                                            <option value="<?php echo $geo_zone['geo_zone_id']; ?>"><?php echo $geo_zone['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_checkout_status" id="input-status" class="form-control">
                                <?php if ($ecomprocessing_checkout_status) { ?>
                                    <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                    <option value="0"><?php echo $text_disabled; ?></option>
                                <?php } else { ?>
                                    <option value="1"><?php echo $text_enabled; ?></option>
                                    <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_debug; ?></label>
                        <div class="col-sm-10">
                            <select name="ecomprocessing_checkout_debug" id="input-status" class="form-control">
                                <?php if ($ecomprocessing_checkout_debug) { ?>
                                    <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                    <option value="0"><?php echo $text_disabled; ?></option>
                                <?php } else { ?>
                                    <option value="1"><?php echo $text_enabled; ?></option>
                                    <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-sort-order"><?php echo $entry_sort_order; ?></label>
                        <div class="col-sm-10">
                            <input type="text" name="ecomprocessing_checkout_sort_order" value="<?php echo $ecomprocessing_checkout_sort_order; ?>" placeholder="<?php echo $entry_sort_order; ?>" id="input-sort-order" class="form-control" />
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?php echo $footer; ?>