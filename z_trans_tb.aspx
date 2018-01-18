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
			aPop = new Array(['txtXcarno', 'lblXcarno', 'car2', 'a.noa,driverno,driver', 'txtXcarno', 'car2_b.aspx'], ['txtXstraddr', 'lblXstraddr', 'addr2', 'noa,addr', 'txtXstraddr', 'addr2_b.aspx'], ['txtXendaddr', 'lblXendaddr', 'addr2', 'noa,addr', 'txtXendaddr', 'addr2_b.aspx']);
			if (location.href.indexOf('?') < 0) {
				location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
			}
			function z_tran() {
			}


			z_tran.prototype = {
				data : {
					carteam : null,
					calctypes : null,
					calctype : null,
					carkind : null,
					acomp : null
				}
			};
			t_data = new z_tran();
			$(document).ready(function() {
				_q_boxClose();
				q_getId();
				q_gt('carkind', '', 0, 0, 0, "");
			});
			function q_gfPost() {
				loadFinish();
			}

			function q_gtPost(t_name) {
				switch (t_name) {
					case 'carkind':
						t_data.data['carkind'] = '';
						var as = _q_appendData("carkind", "", true);
						for ( i = 0; i < as.length; i++) {
							t_data.data['carkind'] += (t_data.data['carkind'].length > 0 ? ',' : '') + as[i].noa + '@' + as[i].kind;
						}
						q_gt('carteam', '', 0, 0, 0, "");
						break;
					case 'carteam':
						t_data.data['carteam'] = '';
						var as = _q_appendData("carteam", "", true);
						for ( i = 0; i < as.length; i++) {
							t_data.data['carteam'] += (t_data.data['carteam'].length > 0 ? ',' : '') + as[i].noa + '@' + as[i].team;
						}
						q_gt('calctype', '', 0, 0, 0);
						break;
					case 'calctype':
						t_data.data['calctype'] = '';
						var as = _q_appendData("calctype", "", true);
						for ( i = 0; i < as.length; i++) {
							t_data.data['calctype'] += (t_data.data['calctype'].length > 0 ? ',' : '') + 'calctype_' + as[i].noa + '@' + as[i].namea;
						}
						q_gt('calctype2', '', 0, 0, 0, "calctypes");
						break;
					case 'calctypes':
						t_data.data['calctypes'] = '';
						var as = _q_appendData("calctypes", "", true);
						for ( i = 0; i < as.length; i++) {
							t_data.data['calctypes'] += (t_data.data['calctypes'].length > 0 ? ',' : '') + as[i].noa + as[i].noq + '@' + as[i].typea;
						}
						q_gt('acomp', '', 0, 0, 0);
						break;
					case 'acomp':
						t_data.data['acomp'] = '';
						var as = _q_appendData("acomp", "", true);
						for ( i = 0; i < as.length; i++) {
							t_data.data['acomp'] += ',' + as[i].acomp;
						}
						q_gf('', 'z_trans_tb');
						break;
				}
			}

			function q_boxClose(t_name) {
			}

			function loadFinish() {
				$('#q_report').q_report({
					fileName : 'z_trans_tb',
					options : [{//[1][2]
						type : '1', name : 'date'
					}, {//[3][4]
						type : '1', name : 'trandate'
					}, {//[5][6]
						type : '2', name : 'cust', dbf : 'cust', index : 'noa,comp', src : 'cust_b.aspx'
					}, {//[7][8]
						type : '2', name : 'driver', dbf : 'driver', index : 'noa,namea', src : 'driver_b.aspx'
						//************************************************//
					}, {//[9]
						type : '6', name : 'xcarno'
					}, {//[10]
						type : '6', name : 'xpo'
					}, {//[11]
						type : '6', name : 'xstraddr'
					}, {//[12]
						type : '6', name : 'xendaddr'
						//************************************************//
					}, {//[13]
						type : '8', name : 'xcalctypes', value : t_data.data['calctypes'].split(',')
					}, {//[14]
						type : '8', name : 'xcarkind', value : t_data.data['carkind'].split(',')
					}, {//[15]
						type : '6', name : 'ycheckrate'
					}, {//[16]排序(耗油比、交運日期、司機、年份、收入、淨利)
						type : '5', name : 'ysort01', value : q_getMsg('tsort01').split('&')
						//************************************************//
					}, {//[17]其他設定(出車明細、加油明細)
						type : '8', name : 'yfilter', value : q_getMsg('tfilter').split('&')
					}, {//[18]其他設定(指定車牌)
						type : '8', name : 'yoption01', value : q_getMsg('toption').split('&')
					}, {//[19]
						type : '0', name : 'accy', value : q_getId()[4]
					}, {//[20]其他選項-(收金額、發金額)
						type : '5', name : 'xoption1', value : q_getMsg('toption1').split('&')
					}, {//[21]公司
						type : '5', name : 'xacomp', value : t_data.data['acomp'].split(',')
						//************************************************//
					}, {//[22]選項-(公司車折扣、外車折扣)
						type : '8', name : 'xoption3', value : q_getMsg('toption3').split('&')
					}, {//[23]排序(客戶、PO)
						type : '5', name : 'xsort14', value : q_getMsg('tsort14').split('&')
					}, {//[24]排序(客戶編號、收金額)
						type : '5', name : 'xsort18', value : q_getMsg('tsort18').split('&')
					}, {//[25]欄位顯示
						type : '8', name : 'xfield05', value : q_getMsg('tfield05').split('&')
						//************************************************//
					}, {//[26]車隊
						type : '8', name : 'xcarteam', value : t_data.data['carteam'].split(',')
					}, {//[27] 其他設定
						type : '8', name : 'yoption28', value : q_getMsg('toption28').split('&')
					}]
				});
				q_popAssign();
				q_langShow();
				$('#txtDate1').mask(r_picd);
				$('#txtDate2').mask(r_picd);
				$('#txtTrandate1').mask(r_picd);
				$('#txtTrandate2').mask(r_picd);
				
				$('#chkXcalctypes').children('input').attr('checked', 'checked');
				$('#chkXcarkind').children('input').attr('checked', 'checked');
				$('#chkXcarteam').children('input').attr('checked', 'checked');
				
				if(r_picd.length==9){
					$('#txtDate1').datepicker();
					$('#txtDate2').datepicker();
					$('#txtTrandate1').datepicker();
					$('#txtTrandate2').datepicker();
				}
			}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>