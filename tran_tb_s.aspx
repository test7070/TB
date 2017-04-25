<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			var q_name = "tran_wh_s";
			var q_readonly = [];
			aPop = new Array();
			$(document).ready(function() {
				main();
			});
			function main() {
				mainSeek();
				q_gf('', q_name);
			}

			function q_gfPost() {
				q_getFormat();
				q_langShow();
				bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]
					,['txtBtrandate', r_picd], ['txtEtrandate', r_picd]];
                q_mask(bbmMask);
                $('#txtBdate').datepicker();
                $('#txtEdate').datepicker();
                $('#txtBtrandate').datepicker();
                $('#txtEtrandate').datepicker();
			}

			function q_gtPost(t_name) {
				switch (t_name) {
				}
			}

			function q_seekStr() {
				var t_bdate = $.trim($('#txtBdate').val());
                var t_edate = $.trim($('#txtEdate').val());
                var t_btrandate = $.trim($('#txtBtrandate').val());
                var t_etrandate = $.trim($('#txtEtrandate').val());
				var t_noa = $.trim($('#txtNoa').val());
				var t_cust = $.trim($('#txtCust').val());
				var t_driver = $.trim($('#txtDriver').val());
				var t_carno = $.trim($('#txtCarno').val());
				var t_caseno = $.trim($('#txtCaseno').val());
				
				var t_a01 = $.trim($('#txtA01').val());
				
				var t_where = " 1=1 " 
					+ q_sqlPara2("datea", t_bdate,t_edate) 
					+ q_sqlPara2("trandate", t_btrandate,t_etrandate) 
					+ q_sqlPara2("noa", t_noa);
				
				if(t_driver.length>0)
					t_where += " and ( charindex('"+t_driver+"',driver)>0 or charindex('"+t_driver+"',driverno)>0 )";
				if(t_carno.length>0)
					t_where += " and charindex('"+t_carno+"',carno)>0";
						
				if(t_cust.length>0)
		       		t_where += " and exists(select noa from view_trans"+r_accy+" where view_trans"+r_accy+".noa=view_tran"+r_accy+".noa and ( charindex('"+t_cust+"',view_trans"+r_accy+".custno)>0 or charindex('"+t_cust+"',view_trans"+r_accy+".comp)>0 or charindex('"+t_cust+"',view_trans"+r_accy+".nick)>0))";
		       	if(t_a01.length>0)
		       		t_where += " and exists(select noa from view_trans"+r_accy+" where view_trans"+r_accy+".noa=view_tran"+r_accy+".noa and ( charindex('"+t_a01+"',view_trans"+r_accy+".po)>0 or charindex('"+t_a01+"',view_trans"+r_accy+".so)>0 or charindex('"+t_a01+"',view_trans"+r_accy+".custorde)>0))";
		       	if(t_caseno.length>0)
		       		t_where += " and exists(select noa from view_trans"+r_accy+" where view_trans"+r_accy+".noa=view_tran"+r_accy+".noa and ( charindex('"+t_caseno+"',view_trans"+r_accy+".caseno)>0 or charindex('"+t_caseno+"',view_trans"+r_accy+".caseno2)>0 ))";
		       	
		       	/*if(t_carno.length>0)
		       		t_where += " and exists(select noa from view_trans"+r_accy+" where view_trans"+r_accy+".noa=view_tran"+r_accy+".noa and ( charindex('"+t_carno+"',view_trans"+r_accy+".carno)>0 or charindex('"+t_carno+"',view_trans"+r_accy+".carno)>0 )";
		       	*/				
				t_where = ' where=^^' + t_where + '^^ ';
				return t_where;
			}
		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				background-color: #76a2fe;
			}
			input{
				font-size:medium;
			}
			.readonly{
				color: green;
				background: rgb(237, 237, 238);
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek" border="1" cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td style="width:35%;"><a id='lblTrandate'>交運日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBtrandate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEtrandate" type="text" style="width:90px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td style="width:35%;"><a id='lblDatea'>日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate" type="text" style="width:90px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblNoa'>單據編號</a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblDriver'>司機</a></td>
					<td><input class="txt" id="txtDriver" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblCarno'>車牌</a></td>
					<td><input class="txt" id="txtCarno" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblCust'>客戶</a></td>
					<td><input class="txt" id="txtCust" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblA01'>P／O、S／O、憑單</a></td>
					<td><input class="txt" id="txtA01" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblCaseno'>櫃號</a></td>
					<td><input class="txt" id="txtCaseno" type="text" style="width:220px;" /></td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>