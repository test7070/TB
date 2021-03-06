<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_tables = 's';
			var q_name = "tboat";
			var q_readonly = ['txtNoa','txtCust','txtMount','txtMoney','txtTax','txtTotal','txtTotal2','txtWorker','txtWorker2'];
			var q_readonlys = ['txtStraddr','txtEndaddr'];
			var bbmNum = [['txtMount',10,0,1],['txtMoney',10,0,1],['txtTax',10,0,1],['txtTotal',10,0,1],['txtTotal2',10,0,1]];
			var bbsNum = [['txtMount',10,0,1],['txtTotal',10,0,1],['txtTotal2',10,0,1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Noa';
			brwCount2 = 8;
			q_desc = 1;
			
			aPop = new Array(
				['txtCustno', 'lblCustno', 'cust', 'noa,comp,nick,serial', 'txtCustno,txtCust,txtNick,txtSerial', 'cust_b.aspx']
				,['txtStraddrno_', 'btnStraddr_', 'addr2', 'noa,addr', 'txtStraddrno_,txtStraddr_', 'addr2_b.aspx']
				,['txtEndaddrno_', 'btnEndaddr_', 'addr2', 'noa,addr', 'txtEndaddrno_,txtEndaddr_', 'addr2_b.aspx']
				,['txtCardealno_', 'btnCardeal_', 'cardeal', 'noa,nick', 'txtCardealno_,txtCardeal_', 'cardeal_b.aspx']
				,['txtBoatname_', 'btnBoat_', 'boat', 'noa,boat,conn', 'txtBoatname_', 'boat_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1);
			});

			function sum(){
				var t_mount=0,t_money=0,t_tax=0,t_total=0,t_total2=0;
				var t_mounts=0,t_prices=0,t_totals=0,t_total2s=0;
				var t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				$('#txtTax').attr('readonly', true);
				$('#txtTax').css('background-color', 'rgb(237,237,238)').css('color', 'green');
				for(var j=0;j<q_bbsCount;j++){
					//2018/05/31  total改為自行輸入,不由數量*單價計算
					
					t_mounts = q_float('txtMount_'+j);
					//t_prices = q_float('txtPrice_'+j);
					t_totals = q_float('txtTotal_'+j);
					t_total2s = q_float('txtTotal2_'+j);
					t_mount = q_add(t_mount,t_mounts);
					t_total2 += t_total2s; 
					switch($.trim(($('#cmbTaxtype').val()))){
						case '1': // 應稅
							t_tax = q_add(t_tax,round(q_mul(t_totals,t_taxrate), 0));
							t_money = q_add(t_money,t_totals);
							break;
						case '2': //零稅率
							t_tax = 0;
							t_money = q_add(t_money,t_totals);
							break;
						case '3': // 內含
							t_tax = q_add(t_tax,q_sub(t_totals,round(q_div(t_totals, q_add(1, t_taxrate)), 0)));
							t_money = q_add(t_money,q_sub(t_totals,q_sub(t_totals,round(q_div(t_totals, q_add(1, t_taxrate)), 0))));
							break;
						case '4': // 免稅
							t_tax = 0;
							t_money = q_add(t_money,t_totals);
							break;
						case '5': // 自定
							$('#txtTax').attr('readonly', false);
							$('#txtTax').css('background-color', 'white').css('color', 'black');
							t_tax = round(dec($('#txtTax').val()),0);
							t_money = q_add(t_money,t_totals);
							break;
						case '6': // 作廢
							break;
						default:
							break;
					}
					$('#txtTotal_'+j).val(t_totals);
				}
				t_total = q_add(t_money,t_tax);
				$('#txtMount').val(t_mount);
				$('#txtMoney').val(t_money);
				$('#txtTax').val(t_tax);
				$('#txtTotal').val(t_total);
				$('#txtTotal2').val(t_total2);
			}

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea',r_picd],['txtInvodate',r_picd]];
				bbsMask = [['txtTrandate',r_picd]];
				q_mask(bbmMask);
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("cmbTypea", q_getPara('tboat.type'));
				$('#cmbTaxtype').change(function(){
					sum();
				});
				$('#txtMount').change(function(){
					sum();
				});
				$('#txtMoney').change(function(){
					sum();
				});
				$('#txtTax').change(function(){
					sum();
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			function q_gtPost(t_name) {
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				if($.trim($('#txtDatea').val()).length==0){
					alert('請輸入日期');
					return;
				}
				sum();
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				var t_date = trim($('#txtDatea').val()).replace(/\//g,'');
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll('M' + t_date, '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
			}

			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					$('#lblNo_' + i).text(i + 1);
                	if($('#btnMinus_' + i).hasClass('isAssign'))
                    	continue;
                	$('#txtBoatname_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnBoat_'+n).click();
                    });
                	$('#txtCardealno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnCardeal_'+n).click();
                    });	
                    $('#txtStraddrno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnStraddr_'+n).click();
                    });	
                    $('#txtEndaddrno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnEndaddr_'+n).click();
                    });		
					$('#txtMount_'+i).change(function(){
						sum();
					});
					$('#txtPrice_'+i).change(function(){
						sum();
					});
					$('#txtTotal_'+i).change(function(){
						sum();
					});
					$('#txtTotal2_'+i).change(function(){
						sum();
					});
					$('#txtCaseno_'+i).change(function(){
						$(this).val($.trim($(this).val().toUpperCase()));
					});
					$('#txtCaseno2_'+i).change(function(){
						$(this).val($.trim($(this).val().toUpperCase()));
					});
						
				}
				_bbsAssign();
			}

			function btnIns() {
				_btnIns();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date()).focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
			}

			function btnPrint() {
				q_box("z_tboat.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa:trim($('#txtNoa').val())}) + ";" + r_accy + "_" + r_cno, 'tboat', "95%", "95%", m_print);
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['trandate']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}
		</script>
		<style type="text/css">
			#dmain {
				/*overflow: hidden;*/
			}
			.dview {
				float: left;
				width: 28%;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
				width: 100%;
			}
			.tview tr {
				height:26px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 70%;
				margin: -1px;
				border: 1px black solid;
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 12%;
			}
			.tbbm .tdZ {
				width: 2%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm td input[type="button"] {
				float: left;
				width: auto;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
			}
			.dbbs {
				width: 1400px;
			}
			.tbbs a {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			.tbbs tr.error input[type="text"] {
				color: red;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.tbbs {
				FONT-SIZE: medium;
				COLOR: blue;
				TEXT-ALIGN: left;
				BORDER: 1PX LIGHTGREY SOLID;
				width: 100%;
				height: 98%;
			}
			.dbbs .tbbs tr td {
				text-align: center;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain'>
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td style="width:80px; color:black;"><a id='vewNoa'> </a></td>
						<td style="width:120px; color:black;"><a id='vewNick'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='nick' style="text-align: center;">~nick</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td><input id="txtCheckno"  type="text" style="display:none;"/></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td class="tdZ"></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTypea" class="lbl"> </a></td>
						<td><select id="cmbTypea" class="txt c1"></select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCustno" class="lbl btn"> </a></td>
						<td colspan="5">
							<input id="txtCustno" type="text" class="txt" style="width:30%;"/>
							<input id="txtCust" type="text" class="txt"  style="width:69%;" />
							<input id="txtNick" type="text" class="txt"  style="display:none;" />
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">統一編號</a></td>
						<td><input id="txtSerial" type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">發票抬頭</a></td>
						<td colspan="3"><input id="txtBuyer" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblInvono" class="lbl"> </a></td>
						<td><input id="txtInvono" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblInvodate" class="lbl"> </a></td>
						<td><input id="txtInvodate" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTaxtype" class="lbl"> </a></td>
						<td><select id="cmbTaxtype" class="txt c1"></select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMount" class="lbl"> </a></td>
						<td><input id="txtMount" type="text" class="txt c1 num"/></td>
						<td><span> </span><a id="lblMoney" class="lbl"> </a></td>
						<td><input id="txtMoney" type="text" class="txt c1 num"/></td>
						<td><span> </span><a id="lblTax" class="lbl"> </a></td>
						<td><input id="txtTax" type="text" class="txt num c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTotal2" class="lbl">應付帳款</a></td>
						<td><input id="txtTotal2" type="text" class="txt c1 num"/></td>
						<td> </td>
						<td> </td>
						<td><span> </span><a id="lblTotal" class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan="5"><input id="txtMemo" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
			<div class='dbbs'>
				<table id="tbbs" class='tbbs'>
					<tr style='color:white; background:#003366;' >
						<td style="width:20px;">
							<input id="btnPlus" type="button" style="font-size: medium; font-weight: bold;" value="＋"/>
						</td>
						<td style="width:20px;"> </td>
						<td style="width:120px;"><a id='lblCardeal_s'>車行</a></td>
						<td style="width:100px;"><a id='lblTrandate_s'> </a></td>
						<td style="width:110px;"><a id='lblBoatname_s'> </a></td>
						<td style="width:80px;"><a id='lblShip_s'> </a></td>
						<td style="width:80px;"><a id='lblSpec_s'> </a></td>
						<td style="width:100px;"><a id='lblCaseno_s'> </a></td>
						<td style="width:100px;"><a id='lblCaseno2_s'> </a></td>
						<td style="width:130px;"><a id='lblStraddrno_s'> </a></td>
						<td style="width:130px;"><a id='lblEndaddrno_s'> </a></td>
						<td style="width:60px;"><a id='lblMount_s'> </a></td>
						<!--<td style="width:80px;"><a id='lblPrice_s'> </a></td>-->
						<td style="width:80px;"><a>應收</a></td>
						<td style="width:80px;"><a>應付</a></td>
						<td style="width:120px;"><a id='lblMemo_s'>備註</a></td>
					</tr>
					<tr  style='background:#cad3ff;'>
						<td align="center">
							<input id="btnMinus.*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input id="txtNoq.*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input type="text" id="txtCardealno.*" class="txt" style="float:left;width:40%;"/>
							<input type="text" id="txtCardeal.*" class="txt" style="float:left;width:50%;"/>
							<input type="button" id="btnCardeal.*" style="display:none;">
						</td>
						<td><input type="text" id="txtTrandate.*" class="txt c1"/></td>
						<td>
							<input type="text" id="txtBoatname.*" class="txt c1"/>
							<input type="button" id="btnBoat.*" style="display:none;"/>
						</td>
						<td><input type="text" id="txtShip.*" class="txt c1"/></td>
						<td><input type="text" id="txtSpec.*" class="txt c1" list="listSpec"/></td>
						<td><input type="text" id="txtCaseno.*" class="txt c1"/></td>
						<td><input type="text" id="txtCaseno2.*" class="txt c1"/></td>
						<td>
							<input id="txtStraddrno.*" type="text" style="width: 35%;float:left;"/>
							<input id="txtStraddr.*" type="text" style="width: 50%;float:left;"/>
							<input type="button" id="btnStraddr.*" style="display:none;">
						</td>
						<td>
							<input id="txtEndaddrno.*" type="text" style="width: 35%;float:left;"/>
							<input id="txtEndaddr.*" type="text" style="width: 50%;float:left;"/>
							<input type="button" id="btnEndaddr.*" style="display:none;">
						</td>
						<td><input type="text" id="txtMount.*" class="txt num c1"/></td>
						<!--<td><input type="text" id="txtPrice.*" class="txt num c1"/></td>-->
						<td><input type="text" id="txtTotal.*" class="txt num c1"/></td>
						<td><input type="text" id="txtTotal2.*" class="txt num c1"/></td>
						<td><input type="text" id="txtMemo.*" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
		<datalist id="listSpec"> 
			<option>20'E</option>
			<option>40'E</option>
			<option>20'F</option>
			<option>40'F</option>
		</datalist>
	</body>
</html>