<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">

            var q_name = "tranordejs", t_content = "where=^^['')^^", bbsKey = ['noa','noq'], as;
            var isBott = false;
            var txtfield = [], afield, t_data, t_htm, t_bbsTag = 'tbbs';
       		brwCount = -1;
			brwCount2 = -1;
			
			var _para = {};
			
            $(document).ready(function() {
                main();
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                var t_para = new Array();
	            try{
	            	t_para = JSON.parse(decodeURIComponent(q_getId()[5]));
	            	_para = t_para;
	            	if(t_para.condition.length>0)
	            		$('#txtCondition').val(t_para.condition);
	            	t_content = "where=^^['"+t_para.project+"','"+t_para.noa+"',"+t_para.chk1+","+t_para.chk2+",'"+t_para.condition+"')^^";
	            }catch(e){
	            }    
                brwCount = -1;
                mainBrow(0, t_content);
            }
			function mainPost() {
				$('#btnTop').hide();
				$('#btnPrev').hide();
				$('#btnNext').hide();
				$('#btnBott').hide();
				
				$('#btnSearch').click(function() {
					var t_condition = $.trim($('#txtCondition').val());
					var t_para = _para;
					t_para.condition = t_condition;
					location.href = "http://"+location.host +location.pathname+"?" + r_userno + ";" + r_name + ";" + q_id + ";;"+r_accy+";"+JSON.stringify(t_para);
				});
			}
            function q_gtPost(t_name) {
				switch (t_name) {
					case q_name:
						abbs = _q_appendData(q_name, "", true);
						//refresh();
						break;
				}
			}
			var maxAbbsCount = 0;
            function refresh() {
            	//ref ordest_b.aspx
				var w = window.parent;
				
				if (maxAbbsCount < abbs.length) {
					for (var i = (abbs.length - (abbs.length - maxAbbsCount)); i < abbs.length; i++) {
						
						for (var j = 0; j < w.q_bbsCount; j++) {
							if (w.$('#txtOrdeno_' + j).val() == abbs[i].noa 
								&& w.$('#txtNo2_' + j).val() == abbs[i].noq
								//&& (w.$('#chkChk1_' + j).prop('checked').toString() == abbs[i].chk1.toString())
								//&& (w.$('#chkChk2_' + j).prop('checked').toString() == abbs[i].chk2.toString()) 
								) {			
								abbs[i]['sel'] = "true";
								$('#chkSel_' + abbs[i].rec).attr('checked', true);
								//alert(abbs[i].rec);
							}
						}
					}
					maxAbbsCount = abbs.length;
				}
				/*abbs.sort(function(a,b){
					var x = (a.sel==true || a.sel=="true"?1:0);
					var y = (b.sel==true || b.sel=="true"?1:0);
					return y-x;
				});*/
				/*for(var i=0;i<abbs.length;i++){
					if(abbs[i].kind == ''){
						abbs.splice(i,1);
						i--;
					}
				}*/
				_refresh();
				q_bbsCount = abbs.length;
				
				$('#checkAllCheckbox').click(function() {
					$('input[type=checkbox][id^=chkSel]').each(function() {
						var t_id = $(this).attr('id').split('_')[1];
						if (!emp($('#txtNoa_' + t_id).val()))
							$(this).attr('checked', $('#checkAllCheckbox').is(':checked'));
					});
				});
				for(var i=0;i<q_bbsCount;i++){
					$('#lblNo_'+i).text((i+1));
					if($('#chkIschk1_'+i).prop('checked'))
						$('#chkChk1_'+i).attr('disabled','disabled');
					if($('#chkIschk2_'+i).prop('checked'))
						$('#chkChk2_'+i).attr('disabled','disabled');
					if($('#chkIschk3_'+i).prop('checked'))
						$('#chkChk3_'+i).attr('disabled','disabled');
					if($('#chkIschk4_'+i).prop('checked'))
						$('#chkChk4_'+i).attr('disabled','disabled');
				}
				//_readonlys(true);
			}
		</script>
		<style type="text/css">
		</style>
	</head>

	<body>
		<div  id="dFixedTitle" style="overflow-y: scroll;">
			<table id="tFixedTitle" class='tFixedTitle'  border="2"  cellpadding='2' cellspacing='1' style='width:100%;'  >
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:25px" ><input type="checkbox" id="checkAllCheckbox"/></td>
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:50px;display:none;"><a>趟次</a></td>
					<td align="center" style="width:60px;"><a>類型</a></td>
					<td align="center" style="width:80px;"><a>結關日<BR>重櫃期限</a></td>
					<td align="center" style="width:100px;"><a>船公司</a></td>
					<td align="center" style="width:120px;display:none;"><a>訂單編號</a></td>
					<td align="center" style="width:150px;"><a>貨主</a></td>
					<td align="center" style="width:100px;"><a>品名</a></td>
					<td align="center" style="width:150px;"><a>起迄點</a></td>
					<td align="center" style="width:150px;display:none;"><a>迄點</a></td>
					<td align="center" style="width:80px;"><a>櫃型</a></td>
					<td align="center" style="width:100px;"><a>櫃號</a></td>
					<td align="center" style="width:100px;"><a>S／O</a></td>
					<td align="center" style="width:40px;"><a>領</a></td>
					<td align="center" style="width:40px;"><a>送</a></td>
					<td align="center" style="width:40px;"><a>收</a></td>
					<td align="center" style="width:40px;"><a>交</a></td>
				</tr>
			</table>
		</div>
		<div id="dbbs" style="overflow: scroll;height:400px;" >
			<table id="tbbs" class='tbbs' border="2" cellpadding='2' cellspacing='1' style='width:100%;' >
				<tr style="display:none;">
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:50px;display:none;"> </td>
					<td align="center" style="width:60px;"> </td>
					<td align="center" style="width:80px;"> </td>
					<td align="center" style="width:100px;"> </td>
					<td align="center" style="width:120px;display:none;"> </td>
					<td align="center" style="width:150px;"> </td>
					<td align="center" style="width:100px;"> </td>
					<td align="center" style="width:150px;"> </td>
					<td align="center" style="width:150px;display:none;"> </td>
					<td align="center" style="width:80px;"> </td>
					<td align="center" style="width:100px;"> </td>
					<td align="center" style="width:100px;"> </td>
					<td align="center" style="width:40px;"> </td>
					<td align="center" style="width:40px;"> </td>
					<td align="center" style="width:40px;"> </td>
					<td align="center" style="width:40px;"> </td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td style="width:25px;"><input id="chkSel.*" type="checkbox"/></td>
					<td style="width:25px;"><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="width:50px;display:none;"><input id="txtN.*" type="text" style="width:95%;text-align: center;"/></td>
					<td style="width:60px;"><input id="txtStype.*" type="text" style="width:95%;text-align: center;" readonly="readonly"/></td>
					<td style="width:80px;"><input id="txtDatea2.*" type="text" style="width:95%;text-align: center;" readonly="readonly"/></td>
					<td style="width:100px;">
						<input id="txtVocc.*" type="text" style="float:left;width:95%;"  readonly="readonly" />
					</td>
					<td style="width:120px;display:none;">
						<input id="txtNoa.*" type="text" style="float:left;width:95%;"  readonly="readonly" />
					</td>
					<td style="width:150px;">
						<input id="txtCustno.*" type="text" style="display:none;"/>
						<input id="txtCust.*" type="text" style="float:left;width:95%;" readonly="readonly"/>
					</td>
					<td style="width:100px;">
						<input id="txtProductno.*" type="text" style="display:none;"/>
						<input id="txtProduct.*" type="text" style="float:left;width:95%;" readonly="readonly" />
					</td>
					<td style="width:150px;">
						<input id="txtAddrno.*" type="text" style="display:none;"/>
						<input id="txtAddr.*" type="text" style="float:left;width:95%;" readonly="readonly" />
					</td>
					<td style="width:150px;display:none;">
						<input id="txtAddrno2.*" type="text" style="display:none;"/>
						<input id="txtAddr2.*" type="text" style="float:left;width:95%;" readonly="readonly" />
					</td>
					<td style="width:80px;">
						<input id="txtCasetype.*" type="text" style="float:left;width:95%;" readonly="readonly" />
					</td>
					<td style="width:100px;">
						<input id="txtCaseno.*" type="text" style="float:left;width:95%;" readonly="readonly" />
						<input id="txtCaseno2.*" type="text" style="display:none;" readonly="readonly" />
					</td>
					<td style="width:100px;">
						<input id="txtSo.*" type="text" style="float:left;width:95%;" readonly="readonly" />
					</td>
					<td style="width:40px;">
						<input id="chkChk1.*" type="checkbox" style="float:left;width:95%;"/>
						<input id='chkIschk1.*' type="checkbox" style="display:none;"/>
					</td>
					<td style="width:40px;">
						<input id="chkChk2.*" type="checkbox" style="float:left;width:95%;"/>
						<input id='chkIschk2.*' type="checkbox" style="display:none;"/>
					</td>
					<td style="width:40px;">
						<input id="chkChk3.*" type="checkbox" style="float:left;width:95%;"/>
						<input id='chkIschk3.*' type="checkbox" style="display:none;"/>
					</td>
					<td style="width:40px;">
						<input id="chkChk4.*" type="checkbox" style="float:left;width:95%;"/>
						<input id='chkIschk4.*' type="checkbox" style="display:none;"/>
					</td>
				</tr>
			</table>
		</div>
		<div>
			<a>類型、櫃號</a>
			<input class="txt" id="txtCondition" list="listTypea" type="text" style="width:150px;" />
			<datalist id="listTypea"> 
				<option>進口</option>
				<option>出口</option>
			</datalist>
			<input type="button" id="btnSearch" style="border-style: none; width: 26px; height: 26px; cursor: pointer; background: url(../image/search_32.png) 0px 0px no-repeat;background-size: 100%;">
		 </div>
		<!--#include file="../inc/pop_ctrl.inc"-->
	</body>
</html>

