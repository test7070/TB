<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				q_getId();
				q_gf('', 'z_tboat');
			});
			aPop = new Array(
				['txtXstraddr', 'lblXstraddr', 'addr2', 'noa,addr', 'txtXstraddr', 'addr2_b.aspx'],
				['txtXendaddr', 'lblXendaddr', 'addr2', 'noa,addr', 'txtXendaddr', 'addr2_b.aspx']
			);
			function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_tboat',
					options : [{
						//[1]
						type : '0', name : 'accy', value : r_accy
					}, {
						//[2][3]
						type : '1', name : 'xnoa'
					}, {
						//[4]
						type : '5', name : 'xtypea', value : [q_getPara('report.all')].concat(q_getPara('tboat.type').split(','))
					}, {
						//[5]
						type : '6', name : 'xinvono'
					}, {
						//[6][7]
						type : '1', name : 'xtrandate'
					}, {
						//[8]
						type : '6', name : 'xstraddr'
					}, {
						//[9]
						type : '6', name : 'xendaddr'
					}, {
						//[10][11]
						type : '2', name : 'cust', dbf : 'cust', index : 'noa,comp', src : 'cust_b.aspx'
					}]
				});
				q_popAssign();
				q_getFormat();
				q_langShow();

				$('#txtXtrandate1').mask('999/99/99');
				$('#txtXtrandate1').datepicker();
				$('#txtXtrandate2').mask('999/99/99');
				$('#txtXtrandate2').datepicker();

				var t_date, t_year, t_month, t_day;
				t_date = new Date();
				t_date.setDate(1);
				t_year = t_date.getUTCFullYear() - 1911;
				t_year = t_year > 99 ? t_year + '' : '0' + t_year;
				t_month = t_date.getUTCMonth() + 1;
				t_month = t_month > 9 ? t_month + '' : '0' + t_month;
				t_day = t_date.getUTCDate();
				t_day = t_day > 9 ? t_day + '' : '0' + t_day;
				$('#txtXtrandate1').val(t_year + '/' + t_month + '/' + t_day);

				t_date = new Date();
				t_date.setDate(35);
				t_date.setDate(0);
				t_year = t_date.getUTCFullYear() - 1911;
				t_year = t_year > 99 ? t_year + '' : '0' + t_year;
				t_month = t_date.getUTCMonth() + 1;
				t_month = t_month > 9 ? t_month + '' : '0' + t_month;
				t_day = t_date.getUTCDate();
				t_day = t_day > 9 ? t_day + '' : '0' + t_day;
				$('#txtXtrandate2').val(t_year + '/' + t_month + '/' + t_day);
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(s2) {
			}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>