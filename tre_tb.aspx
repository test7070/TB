<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
    <head>
        <title></title>
        <script src="../script/jquery.min.js" type="text/javascript"></script>
        <script src='../script/qj2.js' type="text/javascript"></script>
        <script src='qset.js' type="text/javascript"></script>
        <script src='../script/qj_mess.js' type="text/javascript"></script>
        <script src='../script/mask.js' type="text/javascript"></script>
        <script src="../script/qbox.js" type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
        <script src="css/jquery/ui/jquery.ui.core.js"></script>
        <script src="css/jquery/ui/jquery.ui.widget.js"></script>
        <script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
        <script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_tables = 's';
			var q_name = "tre";
			var q_readonly = ['txtAccno', 'txtNoa', 'txtMoney', 'txtTotal', 'txtCarchgno', 'txtWorker2', 'txtWorker', 'txtRc2ano', 'txtPaydate', 'txtPlusmoney', 'txtMinusmoney', 'txtAccno', 'txtAccno2', 'txtYear2', 'txtYear1'];
			var q_readonlys = ['txtOrdeno', 'txtTranno', 'txtTrannoq', 'txtTranaccy','txtMount','txtPrice','txtDiscount','txtMoney'];
			var bbmNum = [['txtMoney', 10, 0], ['txtTotal', 10, 0], ['txtPlusmoney', 10, 0], ['txtMinusmoney', 10, 0]];
			var bbsNum = [['txtMount', 10, 3], ['txtPrice', 10, 3], ['txtDiscount', 10, 3], ['txtMoney', 10, 0]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			q_desc = 1;
			aPop = new Array(['txtCarno', 'lblCarno', 'car2', 'a.noa,driverno,driver', 'txtCarno,txtDriverno,txtDriver', 'car2_b.aspx'], ['txtTggno', 'lblTgg', 'tgg', 'noa,comp', 'txtTggno,txtTggcomp', 'tgg_b.aspx'], ['txtDriverno', 'lblDriver', 'driver', 'noa,namea', 'txtDriverno,txtDriver', 'driver_b.aspx'], ['txtBdriverno', '', 'driver', 'noa,namea', 'txtBdriverno', 'driver_b.aspx'], ['txtEdriverno', '', 'driver', 'noa,namea', 'txtEdriverno', 'driver_b.aspx']);
			q_xchg = 1;
			brwCount2 = 20;
			function tre() {
			}
			tre.prototype = {
				isLoad : false, carchgno : new Array()
			};
			$(document).ready(function() {
				q_bbsShow = -1;
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
			});
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
				$('#txtBcarno').val('0');
				$('#txtEcarno').val('zz');
			}
			function mainPost() {
				q_modiDay = q_getPara('sys.modiday2');
				/// 若未指定， d4=  q_getPara('sys.modiday');
				q_getFormat();
				bbmMask = [['textDatea', r_picd], ['textBBdate', r_picd], ['textEEdate', r_picd], ['txtDatea', r_picd], ['txtDate2', r_picd], ['txtBdate', r_picd], ['txtEdate', r_picd], ['txtPaydate', r_picd]];
				q_mask(bbmMask);
				$('#lblAccno').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtYear1').val() + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('popAccc'), true);
				});
				$('#lblAccno2').click(function() {
					q_pop('txtAccno2', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno2').val() + "';" + $('#txtYear2').val() + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('popAccc'), true);
				});
				$('#txtPlusmoney').change(function(e) {
					sum();
				});
				$('#txtMinusmoney').change(function(e) {
					sum();
				});
				$('#lblCarchgno').click(function(e) {
					var t_where = "1!=1";
					var t_carchgno = $('#txtCarchgno').val().split(',');
					for (var i in t_carchgno) {
						if (t_carchgno[i].length > 0)
							t_where += " or noa='" + t_carchgno[i] + "'";
					}
					q_box("carchg.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where + ";" + r_accy + '_' + r_cno, 'carchg', "95%", "95%", q_getMsg("popCarchg"));
				});
				$("#btnCarchg").click(function(e) {
					var t_carchgno = '';
					if (curData.isLoad) {
						for (var i = 0; i < curData.carchgno.length; i++)
							t_carchgno += (t_carchgno.length > 0 ? ',' : '') + curData.carchgno[i];
						t_carchgno = 'carchgno=' + t_carchgno;
					}
					t_where = " driverno='" + $('#txtDriverno').val() + "' and  (treno='" + $('#txtNoa').val() + "' or len(isnull(treno,''))=0) ";
					q_box("carchg_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where + ";;" + t_carchgno + ";", 'carchg', "95%", "650px", q_getMsg('popCarchg'));
				});
				//---------------------------------------------------------------
				$('#textBBdate').datepicker();
				$('#textEEdate').datepicker();
				$('#btnTrans').click(function(e) {
					$('#divExport').toggle();
				});
				$('#btnDivexport').click(function(e) {
					$('#divExport').hide();
				});
				$('#btnExport').click(function(e) {
					var t_datea = $('#textDatea').val();
					var t_bdate = $('#textBBdate').val();
					var t_edate = $('#textEEdate').val();
					if (t_datea.length > 0 && t_bdate.length > 0 && t_edate.length > 0) {
						Lock(1, {
							opacity : 0
						});
						q_func('qtxt.query.tre', 'tre.txt,tre_tb,' + encodeURI(r_userno) + ';' + encodeURI(r_name) + ';' + encodeURI(q_getPara('sys.key_tre')) + ';' + encodeURI(t_datea) + ';' + encodeURI(t_bdate) + ';' + encodeURI(t_edate));
					} else
						alert('請輸入日期。');
				});
				$('#textBBdate').keydown(function(e) {
					if (e.which == 13)
						$('#textEEdate').focus();
				});
			}
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.tre':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								q_func('tre_post.post', as[i].noa.substring(2, 5) + ',' + as[i].noa + ',0');
								// post 0
								q_func('tre_post.post', as[i].noa.substring(2, 5) + ',' + as[i].noa + ',1');
								// post 1
							}
						}
						location.reload();
						break;
				}
			}
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'carchg':
						if (b_ret != null) {
							var t_where = '1!=1';
							curData.isLoad = true;
							curData.carchgno = new Array();
							var t_carchgno = '';
							for (var i = 0; i < b_ret.length; i++) {
								curData.carchgno.push(b_ret[i].noa);
								t_where += " or noa='" + b_ret[i].noa + "'";
								t_carchgno += (t_carchgno.length > 0 ? ',' : '') + b_ret[i].noa;
							}
							$('#txtCarchgno').val(t_carchgno);
							q_gt('carchg', "where=^^" + t_where + "^^", 0, 0, 0, "");
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'carchg':
						var as = _q_appendData("carchg", "", true);
						var t_plusmoney = 0, t_minusmoney = 0;
						for ( i = 0; i < as.length; i++) {
							t_plusmoney += parseFloat(as[i].plusmoney);
							t_minusmoney += parseFloat(as[i].minusmoney);
						}
						$('#txtPlusmoney').val(t_plusmoney);
						$('#txtMinusmoney').val(t_minusmoney);
						sum();
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}
			function btnOk() {
				$('#txtDatea').val($.trim($('#txtDatea').val()));
				if ($('#txtDatea').val().length==0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					return;
				}
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				sum();
				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_tre') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}
			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('tre_tb_s.aspx', q_name + '_s', "530px", "530px", q_getMsg("popSeek"));
			}
			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
                    $('#lblNo_' + j).text(j + 1);
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                        $('#txtTranno_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtTranno_', '');
                            var t_accy = $('#txtTranaccy_' + n).val();
                            q_box("trans_tb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, 'trans', "95%", "95%", q_getMsg("popTrans"));
                            
                        });
                        $('#txtPrice_'+j).change(function(e){
                            sum();
                        });
                    }
                }
                _bbsAssign();
			}
			function btnIns() {
				_btnIns();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				curData = new tre();
			}
			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				if (q_chkClose())
					return;
				_btnModi();
				$('#txtDatea').focus();
				curData = new tre();
				sum();
			}
			function btnPrint() {
				q_box('z_tre_tb.aspx' + "?;;;;" + r_accy + ";datea=" + abbm[q_recno].datea, '', "95%", "95%", q_getMsg("popPrint"));
			}
			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}
			function bbsSave(as) {
				if (!as['tranno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}
			function sum() {
				if (!(q_cur == 1 || q_cur == 2))
					return;
				var t_money = 0, t_moneys = 0, t_total = 0;
				for ( i = 0; i < q_bbsCount; i++) {
				    //t_money = round(q_mul(q_mul(q_float('txtMount_'+i),q_float('txtPrice_'+i)),q_fload('txtDiscount')),0);
				    //$('#txtMoney_'+i).val(t_money);
					t_money = q_float('txtMoney_'+i);
					t_moneys += t_money;
				}
				t_plusmoney = q_float('txtPlusmoney');
				t_minusmoney = q_float('txtMinusmoney');
				t_total = t_moneys + t_plusmoney - t_minusmoney;
				$('#txtMoney').val(t_moneys);
				$('#txtTotal').val(t_total);
			}
			function refresh(recno) {
				_refresh(recno);
			}
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (q_cur == 1 || q_cur == 2) {
					$('#btnTrans').hide();
					$('#btnCarchg').removeAttr('disabled');
				} else {
					$('#btnTrans').show();
					$('#btnCarchg').attr('disabled', 'disabled');
				}
			}
			function btnMinus(id) {
				_btnMinus(id);
				sum();
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
				if (q_chkClose())
					return;
				_btnDele();
			}
			function btnCancel() {
				_btnCancel();
			}
			
        </script>
        <style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 950px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 950px;
                /*margin: -1px;
                 border: 1px black solid;*/
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
                width: 10%;
            }
            .tbbm .tr1 {
                background-color: #FFEC8B;
            }
            .tbbm .tr_carchg {
                background-color: #DAA520;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            td .schema {
                display: block;
                width: 95%;
                height: 0px;
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
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 100%;
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
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            .dbbs {
                width: 2400px;
            }
            .tbbs a {
                font-size: medium;
            }

            .num {
                text-align: right;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
        </style>
    </head>
    <body ondragstart="return false" draggable="false"
    ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
    ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    >
        <div id="divExport" style="display:none;position:absolute;top:100px;left:600px;width:400px;height:120px;background:RGB(237,237,237);">
            <table style="border:4px solid gray; width:100%; height: 100%;">
                <tr style="height:1px;background-color: pink;">
                    <td style="width:25%;"></td>
                    <td style="width:25%;"></td>
                    <td style="width:25%;"></td>
                    <td style="width:25%;"></td>
                </tr>
                <tr>
                    <td style="padding: 2px;text-align: center;border-width: 0px;background-color: pink;color: blue;"><a>立帳日期</a></td>
                    <td colspan="3" style="padding: 2px;text-align: center;border-width: 0px;background-color: pink;">
                    <input type="text" id="textDatea" style="float:left;width:40%;"/>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 2px;text-align: center;border-width: 0px;background-color: pink;color: blue;"><a>出車登錄日期</a></td>
                    <td colspan="3" style="padding: 2px;text-align: center;border-width: 0px;background-color: pink;">
                    <input type="text" id="textBBdate" style="float:left;width:40%;"/>
                    <span style="float:left;width:5%;">~</span>
                    <input type="text" id="textEEdate" style="float:left;width:40%;"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center" style="background-color: pink;">
                    <input type="button" id="btnExport" value="匯出"/>
                    </td>
                    <td colspan="2" align="center" style=" background-color: pink;">
                    <input type="button" id="btnDivexport" value="關閉"/>
                    </td>
                </tr>
            </table>
        </div>
        <!--#include file="../inc/toolbar.inc"-->
        <div id='dmain' >
            <div class="dview" id="dview">
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
                        <td align="center" style="width:100px; color:black;"><a id='vewDatea'> </a></td>
                        <td align="center" style="width:140px; color:black;"><a id='vewDriver'> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id='vewMoney'> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id='vewPlusmoney'> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id='vewMinusmoney'> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id='vewTotal'> </a></td>
                    </tr>
                    <tr>
                        <td >
                        <input id="chkBrow.*" type="checkbox" />
                        </td>
                        <td id="datea" style="text-align: center;">~datea</td>
                        <td id="driver" style="text-align: center;">~driver</td>
                        <td id="money,0,1" style="text-align: right;">~money,0,1</td>
                        <td id="plusmoney,0,1" style="text-align: right;">~plusmoney,0,1</td>
                        <td id="minusmoney,0,1" style="text-align: right;">~minusmoney,0,1</td>
                        <td id="total,0,1" style="text-align: right;">~total,0,1</td>
                    </tr>
                </table>
            </div>
            <div class='dbbm'>
                <table class="tbbm"  id="tbbm">
                    <tr name="schema" style="height:1px;">
                        <td class="td1"><span class="schema"> </span></td>
                        <td class="td2"><span class="schema"> </span></td>
                        <td class="td3"><span class="schema"> </span></td>
                        <td class="td4"><span class="schema"> </span></td>
                        <td class="td5"><span class="schema"> </span></td>
                        <td class="td6"><span class="schema"> </span></td>
                        <td class="td7"><span class="schema"> </span></td>
                        <td class="td8"><span class="schema"> </span></td>
                        <td class="td9"><span class="schema"> </span></td>
                        <td class="tdA"><span class="schema"> </span></td>
                        <td class="tdZ"><span class="schema"> </span></td>
                    </tr>
                    <tr>
                        <td>
                        <input type="button" id="btnTrans" class="txt c1"/>
                        </td>
                    </tr>
                    <tr class="tr_carchg">
                        <td><span> </span><a id="lblCarchgno" class="lbl btn"> </a></td>
                        <td colspan="7">
                        <input id="txtCarchgno" type="text" class="txt c1"/>
                        </td>
                        <td></td>
                        <td>
                        <input type="button" id="btnCarchg" class="txt c1"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblDatea" class="lbl"> </a></td>
                        <td><input id="txtDatea" type="text"  class="txt c1"/></td>
                        <td><span> </span><a id="lblNoa" class="lbl"> </a></td>
                        <td colspan="2">
                        <input id="txtNoa" type="text" class="txt c1"/>
                        </td>
                        <td><span> </span><a id="lblDriver" class="lbl"> </a></td>
                        <td colspan="2">
                        <input id="txtDriverno" type="text"  class="txt" style="width:50%;"/>
                        <input id="txtDriver" type="text"  class="txt" style="width:50%;"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td><span> </span><a id="lblMoney" class="lbl"> </a></td>
                        <td>
                        <input id="txtMoney" type="text"  class="txt c1 num"/>
                        </td>
                        <td><span> </span><a id="lblPlusmoney" class="lbl"> </a></td>
                        <td>
                        <input id="txtPlusmoney" type="text" class="txt c1 num" />
                        </td>
                        <td><span> </span><a id="lblMinusmoney" class="lbl"> </a></td>
                        <td>
                        <input id="txtMinusmoney" type="text" class="txt c1 num" />
                        </td>
                        <td><span> </span><a id="lblTotal" class="lbl"> </a></td>
                        <td><input id="txtTotal" type="text" class="txt c1 num" /></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblCheckno" class="lbl"> </a></td>
                        <td colspan="2">
                        <input id="txtCheckno" type="text" class="txt c1" />
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblMemo" class="lbl"> </a></td>
                        <td colspan="6">
                        <input id="txtMemo" type="text" class="txt c1" />
                        </td>
                        <td></td>
                        <td><span> </span><a id="lblWorker" class="lbl"> </a></td>
                        <td>
                        <input id="txtWorker" type="text" class="txt c1" />
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblAccno" class="lbl btn"> </a></td>
                        <td>
                        <input id="txtAccno" type="text"  class="txt c1"/>
                        </td>
                        <td>
                        <input id="txtYear1" type="text"  class="txt c1"/>
                        </td>
                        <td><span> </span><a id="lblAccno2" class="lbl btn"> </a></td>
                        <td>
                        <input id="txtAccno2" type="text"  class="txt c1"/>
                        </td>
                        <td>
                        <input id="txtYear2" type="text"  class="txt c1"/>
                        </td>
                        <td></td>
                        <td></td>
                        <td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
                        <td>
                        <input id="txtWorker2" type="text"  class="txt c1"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <div class='dbbs'>
            <table id="tbbs" class='tbbs'>
                <tr style='color:white; background:#003366;' >
                    <td  align="center" style="width:30px;">
                    <input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
                    </td>
                    <td align="center" style="width:20px;"></td>
                    <td align="center" style="width:100px;"><a id='lblTrandate_s'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblCustno_s'> </a></td>
                    <td align="center" style="width:200px;"><a id='lblStraddr_tb'> </a></td>
                    <td align="center" style="width:200px;"><a id='lblEndaddr_tb'> </a></td>
                    <td align="center" style="width:200px;"><a id='lblProduct_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblMount_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblPrice_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblDiscount_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblMoney_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblMemo_s'> </a></td>
                    <td align="center" style="width:170px;"><a id='lblTranno_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblRs_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblPaymemo_s'> </a></td>
                    <td align="center" style="width:100px;"><a id='lblFill_s'> </a></td>
                    <td align="center" style="width:100px"><a id='lblCasetype_s'> </a></td>
                    <td align="center" style="width:150px;"><a id='lblCaseno_s'> </a></td>
                    <td align="center" style="width:150px;"><a id='lblCaseno2_s'> </a></td>
                </tr>
                <tr style='background:#cad3ff;'>
                    <td align="center">
                    <input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
                    <input id="txtNoq.*" type="text" style="display: none;"/>
                    <input id="txtTranaccy.*" type="text" style="display: none;"/>
                    <input id="txtTrannoq.*" type="text" style="display: none;"/>
                    </td>
                    <td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
                    <td>
                    <input type="text" id="txtTrandate.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtComp.*" style="width:95%;"/>
                    </td >
                    <td>
                    <input type="text" id="txtStraddr.*" style="width:95%;" />
                    </td>
                    <td>
                    <input type="text" id="txtEndaddr.*" style="width:95%;" />
                    </td>
                    <td>
                    <input type="text" id="txtProduct.*" style="width:95%;" />
                    </td>
                    <td>
                    <input type="text" id="txtMount.*" style="width:95%;text-align: right;" />
                    </td>
                    <td>
                    <input type="text" id="txtPrice.*" style="width:95%;text-align: right;" />
                    </td>
                    <td>
                    <input type="text" id="txtDiscount.*" style="width:95%;text-align: right;" />
                    </td>
                    <td>
                    <input type="text" id="txtMoney.*" style="width:95%;text-align: right;"/>
                    </td>
                    <td>
                    <input type="text" id="txtMemo.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtTranno.*" style="float:left;width: 95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtRs.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtPaymemo.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtFill.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtCasetype.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtCaseno.*" style="width:95%;"/>
                    </td>
                    <td>
                    <input type="text" id="txtCaseno2.*" style="width:95%;"/>
                    </td>
                </tr>
            </table>
        </div>
        <input id="q_sys" type="hidden" />
    </body>
</html>