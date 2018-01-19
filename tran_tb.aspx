<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
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
		<!--<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8&signed_in=true&callback=initMap" async defer></script>
		-->
		<script type="text/javascript">
			q_tables = 's';
			var q_name = "tran";
			var q_readonly = ['txtNoa','txtWorker', 'txtWorker2','txtTotal','txtTotal2','textMile','textAvg'];
			var q_readonlys = ['txtOrdeno','txtNo2','txtStraddr'];
			var q_readonlyt = [];
			var bbmNum = new Array();
			var bbmMask = new Array(['txtDatea', '999/99/99'],['txtTrandate', '999/99/99']);
			var bbsNum = new Array(['txtBmile',10,1],['txtEmile',10,1],['txtOil',10,1],['txtTotal',10,1],['txtTotal2',10,1]);
			var bbsMask = new Array();
			var bbtNum  = new Array(); 
			var bbtMask = new Array();
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			q_alias = '';
			q_desc = 1;
			//q_xchg = 1;
			brwCount2 = 7;
			aPop = new Array(['txtUccno_', 'btnProduct_', 'ucc', 'noa,product', 'txtUccno_,txtProduct_', 'ucc_b.aspx']
				,['txtStraddrno_', 'btnStraddr_', 'addr', 'noa,addr', 'txtStraddrno_,txtStraddr_', 'addr_b.aspx']
				,['txtEndaddrno_', 'btnEndaddr_', 'addr', 'noa,addr', 'txtEndaddrno_,txtEndaddr_', 'addr_b.aspx']
				,['txtCarno', 'lblCarno', 'car2', 'a.noa,driverno,driver', 'txtCarno,txtDriverno,txtDriver', 'car2_b.aspx']
				,['txtDriverno', 'lblDriver', 'driver', 'noa,namea', 'txtDriverno,txtDriver', 'driver_b.aspx']
				,['txtCustno_', 'btnCust_', 'cust', 'noa,comp,nick', 'txtCustno_,txtComp_,txtNick_', 'cust_b.aspx']
				,['txtBoatno_', 'btnBoat_', 'boat', 'noa,boat', 'txtBoatno_,txtBoat_', 'boat_b.aspx']);
			
			var t_carteam='', t_calctype='';
			
			function sum() {
				if (!(q_cur == 1 || q_cur == 2))
					return;
				var t_total=0,t_total2=0;
				for(var i=0;i<q_bbsCount;i++){
					/*if(q_float('txtDiscount_'+i)==0)
						$('#txtDiscount_'+i).val(1);
					$('#txtMount_'+i).val(q_add(q_float('txtInmount_'+i),q_float('txtPton_'+i)));
					$('#txtMount2_'+i).val(q_add(q_float('txtOutmount_'+i),q_float('txtPton2_'+i)));
					$('#txtTotal_'+i).val(round(q_mul(q_float('txtMount_'+i),q_float('txtPrice_'+i)),0));
					$('#txtTotal2_'+i).val(round(q_mul(q_mul(q_float('txtMount2_'+i),q_float('txtDiscount_'+i)),q_float('txtPrice2_'+i)),0));
					*/
					var t_mount = ($.trim($('#txtCaseno_'+i).val()).length>0?1:0)+($.trim($('#txtCaseno2_'+i).val()).length>0?1:0);
					t_mount = (t_mount==0?1:t_mount);
					$('#txtMount_'+i).val(t_mount);
					
					t_total = q_add(t_total,q_float('txtTotal_'+i));
					t_total2 = q_add(t_total2,q_float('txtTotal2_'+i));
				}
				$('#txtTotal').val(t_total);
				$('#txtTotal2').val(t_total2);
			}
			
			$(document).ready(function() {
				var t_where = '';
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt('carteam', '', 0, 0, 0, '');
			});
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
			}

			function mainPost() {
				q_mask(bbmMask);
				
				document.title = 'CY 出車作業';
				
				if(t_calctype.length>0)
					q_cmbParse("cmbCalctype", t_calctype, 's');
				if(t_carteam.length>0)
					q_cmbParse("cmbCarteamno", t_carteam, 's');
				
				var t_type = q_getPara('trans.typea').split(',');
				for(var i=0;i<t_type.length;i++){
					$('#listTypea').append('<option value="'+t_type[i]+'"></option>');
				}
				var t_unit = q_getPara('trans.unit').split(',');
				for(var i=0;i<t_unit.length;i++){
					$('#listUnit').append('<option value="'+t_unit[i]+'"></option>');
				}
				var t_cstype = ['領','送','收','交'];
				for(var i=0;i<t_cstype.length;i++){
					$('#listCstype').append('<option value="'+t_cstype[i]+'"></option>');
				}
				var t_ef = ['E','F'];
				for(var i=0;i<t_ef.length;i++){
					$('#listEf').append('<option value="'+t_ef[i]+'"></option>');
				}
				var t_casetype = ['20呎','40呎八半','40呎九半','20呎冷凍櫃','40呎冷凍櫃','平板櫃','開頂櫃'];
				for(var i=0;i<t_casetype.length;i++){
					$('#listCasetype').append('<option value="'+t_casetype[i]+'"></option>');
				}
				
				$('#btnOrde').click(function(e){
                	var t_where ='';
                	q_box("tranordetb_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({project:q_getPara('sys.project').toUpperCase(),noa:$('#txtNoa').val(),chk1:$('#chkChk1').prop('checked')?1:0,chk2:$('#chkChk2').prop('checked')?1:0,condition:''}), "tranorde_tran", "95%", "95%", '');
                });
                
                $('#txtBmile').change(function(e){
					refreshBbs();
				});
				$('#txtEmile').change(function(e){
					refreshBbs();
				});
				$('#txtOil').change(function(e){
					refreshBbs();
				});
			}
			
			//依序上傳
			function UploadFile(n,files,curCount){
				if(curCount>=files.length){
					//done
					return;
				}else{
					var noa = $('#txtNoa').val();
					var noq = $('#txtNoq_'+n).val(); 
					var fr = new FileReader();
					var ext = '';
					var extindex = files[curCount].name.lastIndexOf('.');
					if(extindex>=0){
						ext = files[curCount].name.substring(extindex,files[curCount].name.length);
					}
					fr.filename = files[curCount].name;
					fr.noa = noa;
					fr.noq = noq;
					fr.n = n;
					//abort 事件處理器，於讀取被中斷時觸發。
					fr.onabort = function(e){
						q_msg($('#btnUpload_'+fr.n), '<progress value="50" max="100"></progress>' );
						$('#msg').text("讀取中斷");
						UploadFile(n,files,curCount+1);
					};

					//error 事件處理器，於讀取發生錯誤時觸發。
					fr.onerror = function(e){
						$('#msg').text("讀取錯誤");
						UploadFile(n,files,curCount+1);
					};
					
					//load 事件處理器，於讀取完成時觸發。
					fr.onload = function(e){
						var oReq = new XMLHttpRequest();
						oReq.upload.addEventListener("progress",function(e) {
							if (e.lengthComputable) {
								q_msg($('#btnUpload_'+fr.n), '<a>上傳中...</a><br><progress value="'+Math.round((e.loaded / e.total) * 100,0)+'" max="100"></progress>' );
								//$('#progress').attr('value',Math.round((e.loaded / e.total) * 100,0));
							}
						}, false);
						oReq.upload.addEventListener("load",function(e) {
							q_msg($('#btnUpload_'+fr.n), '<a>上傳開始</a><br><progress value="0" max="100"></progress>' );
							//$('#msg').text("上傳開始");
						    //$('#progress').attr('value',0);
						}, false);
						oReq.upload.addEventListener("error",function(e) {
							q_msg($('#btnUpload_'+fr.n), '<a>上傳發生錯誤</a>');
                            //$('#msg').text("上傳錯誤");
						}, false);
						oReq.addEventListener("loadend", function(e) {
							q_msg($('#btnUpload_'+fr.n), '<a>上傳結束</a>');
							UploadFile(n,files,curCount+1);
						   //$('#msg').text("上傳完成");	
						}, false);
						
						oReq.onreadystatechange = function() {
						    if (oReq.readyState == XMLHttpRequest.DONE) {
						        if(oReq.responseText.length>0)
						        	alert(oReq.responseText);
						    }
						};	
						oReq.timeout = 360000;
						oReq.ontimeout = function () { $('#msg').text("Timed out!!!");};
						oReq.open("POST", 'upload_wh.aspx', true);
						oReq.setRequestHeader("Content-type", "text/plain");
                        oReq.setRequestHeader("filename", fr.filename);
                        oReq.setRequestHeader("noa", fr.noa);
                        oReq.setRequestHeader("noq", fr.noq);
						oReq.send(fr.result);
					};
					
					//loadstart 事件處理器，於讀取開始時觸發。
					fr.onloadstart = function(e){
						q_msg($('#btnUpload_'+fr.n), '<a>開始讀取</a><br><progress value="0" max="100"></progress>' );
                        //$('#msg').text("讀取開始");
						//$('#progress').attr('value',0);
					};
					
					//loadend 事件處理器，於每一次讀取結束之後觸發（不論成功或失敗），會於 onload 或 onerror 事件處理器之後才執行。
					fr.onloadend = function(e){
							
					};
                    //progress 事件處理器，於讀取 Blob 內容時觸發。
                    fr.onprogress = function(e){
						if ( e.lengthComputable ) { 
                        	q_msg($('#btnUpload_'+fr.n), '<a>讀取中...</a><br><progress value="'+Math.round((e.loaded / e.total) * 100,0)+'" max="100"></progress>' );
                            //$('#msg').text("讀取中..."+fr.Filename);
							//$('#progress').attr('value',Math.round( (e.loaded * 100) / e.total));
						}
					};
					
					fr.readAsDataURL(files[curCount]);
				}
			}
			
			
			
            
			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					$('#lblNo_' + i).text(i + 1);
                    if($('#btnMinus_' + i).hasClass('isAssign'))
                    	continue;
                    $('#btnUpload_' + i).click(function(e){
                    	var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                    	UploadFile(n,$('#btnFile_' + n)[0].files,0);
                    });
                    $('#txtTotal_' + i).change(function(e) {
                        sum();
                    });
                    $('#txtDiscount_' + i).change(function(e) {
                        sum();
                    });
                    $('#txtTotal2_' + i).change(function(e) {
                        sum();
                    });
                    $('#txtCustno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnCust_'+n).click();
                    });
                    $('#txtBoat_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnBoat_'+n).click();
                    });
                    $('#txtUccno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnProduct_'+n).click();
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
                    
                    $('#txtCasetype_' + i).change(function(e) {
                        t_IdSeq = -1;
                        q_bodyId($(this).attr('id'));
                        b_seq = t_IdSeq;
                        var t_where = "where=^^ noa='"+$('#txtStraddrno_' + b_seq).val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' and datea=(select top 1 datea from addrs where noa='"+$('#txtStraddrno_' + b_seq).val()+"' and datea<='"+$('#txtTrandate').val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' order by datea desc ) ^^";
                        q_gt('addrs', t_where, 0, 0, 0, "", r_accy,1);
                        
                    });
                    
                    $('#txtCustno_' + i).change(function(e) {
                        t_IdSeq = -1;
                        q_bodyId($(this).attr('id'));
                        b_seq = t_IdSeq;
                        var t_where = "where=^^ noa='"+$('#txtStraddrno_' + b_seq).val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' and datea=(select top 1 datea from addrs where noa='"+$('#txtStraddrno_' + b_seq).val()+"' and datea<='"+$('#txtTrandate').val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' order by datea desc ) ^^";
                        q_gt('addrs', t_where, 0, 0, 0, "", r_accy,1);
                        
                    });
                    
                    $('#txtStraddrno_' + i).change(function(e) {
                        t_IdSeq = -1;
                        q_bodyId($(this).attr('id'));
                        b_seq = t_IdSeq;
                        var t_where = "where=^^ noa='"+$('#txtStraddrno_' + b_seq).val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' and datea=(select top 1 datea from addrs where noa='"+$('#txtStraddrno_' + b_seq).val()+"' and datea<='"+$('#txtTrandate').val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' order by datea desc ) ^^";
                        q_gt('addrs', t_where, 0, 0, 0, "", r_accy,1);  
                    });
                    
                    $('#txtFill_' + i).change(function(e) {
                        t_IdSeq = -1;
                        q_bodyId($(this).attr('id'));
                        b_seq = t_IdSeq;
                        var t_where = "where=^^ noa='"+$('#txtStraddrno_' + b_seq).val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' and datea=(select top 1 datea from addrs where noa='"+$('#txtStraddrno_' + b_seq).val()+"' and datea<='"+$('#txtTrandate').val()+"' and custno='"+$('#txtCustno_' + b_seq).val()+"' and custunit='"+$('#txtCasetype_' + b_seq).val()+"' order by datea desc ) ^^";
                        q_gt('addrs', t_where, 0, 0, 0, "", r_accy,1);
                        
                    });
				}
				_bbsAssign();
				$('#tbbs').find('tr.data').children().hover(function(e){
					$(this).parent().css('background','#F2F5A9');
				},function(e){
					$(this).parent().css('background','#cad3ff');
				});
				refreshBbs();
			}
			function refreshWV(n){
				var t_productno = $.trim($('#txtProductno_'+n).val());
				if(t_productno.length==0){
					$('#txtWeight_'+n).val(0);
					$('#txtVolume_'+n).val(0);
				}else{
					q_gt('ucc', "where=^^noa='"+t_productno+"'^^", 0, 0, 0, JSON.stringify({action:"getUcc",n:n}));
				}
			}

			function bbsSave(as) {
				if (!as['custno'] && !as['straddrno'] && !as['endaddrno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['trandate'] = abbm2['trandate'];
				as['datea'] = abbm2['datea'];
				as['driverno'] = abbm2['driverno'];
				as['driver'] = abbm2['driver'];
				as['carno'] = abbm2['carno'];
				return true;
			}
			function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                	case 'tranorde_tran':
                        if (b_ret != null) {
                        	for(var i=0;i<q_bbsCount;i++)
                        		$('#btnMinus_'+i).click();
                        	as = b_ret;
                        	
                        	//多筆匯入---趟次
                        	for(var i=0;i<as.length;i++){
                        		var n = parseInt(as[i].n);
                        		if(n>1){
                        			as[i].n = 1;
                        			var a = as.slice(0,i);
                        			var b = as.slice(i+1,as.length);
                        			var t = as.slice(i,i+1);
                        			var as = a;
                        			while(n>0){
                        				as = as.concat(t);
                        				n--;
                        			}
                        			as = as.concat(b);
                        		}
                        	}
                        	//多筆匯入---領送收交
                        	var tmp = new Array();
                        	for(var i=0;i<as.length;i++){
                        		var item = new Array();
                        		if(as[i].ischk1=='false' && as[i].chk1=='true')
                        			item.push('chk1');
                        		if(as[i].ischk2=='false' && as[i].chk2=='true')
                        			item.push('chk2');
                        		if(as[i].ischk3=='false' && as[i].chk3=='true')
                        			item.push('chk3');
                    			if(as[i].ischk4=='false' && as[i].chk4=='true')
                        			item.push('chk4');
                        		tmp.push({item:item,as:$.extend(true,[], as.slice(i,i+1))});
                        	}
                        	//console.log(tmp);
                        	var as = new Array();
                        	for(var i=0;i<tmp.length;i++){
                        		if(tmp[i].item.length<=1){
                        			as.push(tmp[i].as[0]);
                        		}else{
                        			tmp[i].as[0].chk1='false';
                        			tmp[i].as[0].chk2='false';
                        			tmp[i].as[0].chk3='false';
                        			tmp[i].as[0].chk4='false';
                        			for(var j=0;j<tmp[i].item.length;j++){
                        				var t = $.extend(true,[], tmp[i].as);
                        				t[0][tmp[i].item[j]] = 'true';
                        				as.push(t[0]);
                        			}
                        		}
                        	}
                        	//console.log(as);
                        	//依狀態判斷  空重櫃
                        	for(var i=0;i<as.length;i++){
                        		if(as[i].ischk1=='false' && as[i].chk1=='true'){
                        			as[i].cstype='領';
                        			as[i].fill=(as[i].typea=='進口'?'F':'E');
                        		}
                        		if(as[i].ischk2=='false' && as[i].chk2=='true'){
                        			as[i].cstype='送';
                        			as[i].fill=(as[i].typea=='進口'?'F':'E');
                        		}
                        		if(as[i].ischk3=='false' && as[i].chk3=='true'){
                        			as[i].cstype='收';
                        			as[i].fill=(as[i].typea=='進口'?'E':'F');
                        		}
                        		if(as[i].ischk4=='false' && as[i].chk4=='true'){
                        			as[i].cstype='交';
                        			as[i].fill=(as[i].typea=='進口'?'E':'F');
                        		}
                        			
                        	}
                        	
                        	while(q_bbsCount<as.length)
                        		$('#btnPlus').click();
                    		q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtCustno,txtComp,txtBoat,txtStraddrno,txtStraddr,txtEndaddrno,txtEndaddr,txtMemo,txtCasetype,txtCaseno,txtCaseno2,txtSo,txtFill,txtCstype'
                        	, as.length, as, 'noa,custno,cust,vocc,addrno,addr,addrno2,addr2,memo,casetype,caseno,caseno2,so,fill,cstype', '','');
                        }else{
                        	Unlock(1);
                        }
                        break;
                	case 'tranvcce_tran':
                        if (b_ret != null) {
                        	for(var i=0;i<q_bbsCount;i++)
                        		$('#btnMinus_'+i).click();
                        	as = b_ret;
                        	while(q_bbsCount<as.length)
                        		$('#btnPlus').click();
                    		q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtCstype,txtCarno,txtCustno,txtComp,txtNick,txtProductno,txtProduct,txtMount,txtUnit,txtVolume,txtWeight,txtStraddrno,txtStraddr,txtEndaddrno,txtEndaddr,txtMemo,txtTotal,txtTotal2,txtReserve'
                        	, as.length, as, 'ordeno,typea,carno,custno,cust,cust,productno,product,mount,unit,volume,weight,straddrno,straddr,endaddrno,endaddr,memo,total,total2,total3', '','');
                        	sum();
                        }else{
                        	Unlock(1);
                        }
                        break;
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop='';
            }
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'carteam':
                		var as = _q_appendData("carteam", "", true);
						t_carteam = "@";
						for ( i = 0; i < as.length; i++) {
							t_carteam += (t_carteam.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].team;
						}
						q_gt('calctype2', '', 0, 0, 0, '');
                		break;
                	case 'calctype2':
                		var as = _q_appendData("calctypes", "", true);
						t_calctype = "@";
						for ( i = 0; i < as.length; i++) {
							t_calctype += (t_calctype.length > 0 ? ',' : '') + as[i].noa + as[i].noq + '@' + as[i].typea;
						}
                		q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                		break;
                    case 'addrs':
                        var as = _q_appendData("addrs", "", true);
                        if (as[0] != undefined){
                            for ( i = 0; i < q_bbsCount; i++) {
                                if ($('#txtFill_'+i).val()=='F' && $('#txtStraddrno_'+i).val()==as[0].noa && $('#txtCustno_'+i).val()==as[0].custno && $('#txtCasetype_'+i).val()==as[0].custunit){
                                   $('#txtTotal_'+i).val(dec(as[0].custprice)); 
                                } 
                            }
                        }
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                    default:
                    	try{
                    		var t_para = JSON.parse(t_name);
                    		if(t_para.action=="getUcc"){
                    			var n = t_para.n;
                    			as = _q_appendData("ucc", "", true);
                    			if(as[0]!=undefined){
                    				$('#txtWeight_'+n).val(round(q_mul(q_float('txtMount_'+n),parseFloat(as[0].uweight)),3));
                    				$('#txtVolume_'+n).val(round(q_mul(q_float('txtMount_'+n),parseFloat(as[0].stkmount)),0));
                    			}else{
                    				$('#txtWeight_'+n).val(0);
                    				$('#txtVolume_'+n).val(0);
                    			}
                    		}else {
							}
							sum();
                		}catch(e){
                    		Unlock(1);
                    	}
                        break;
                }
            }

		
			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('tran_tb_s.aspx', q_name + '_s', "500px", "600px", q_getMsg("popSeek"));
			}

			function btnIns() {
				_btnIns();
				$('#txtNoa').val('AUTO');
				$('#txtTrandate').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtTrandate').focus();
			}

			function btnPrint() {
				q_box('z_trans_tb.aspx?' + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({
		                    form : 'tran_tb'
		                    ,noa : trim($('#txtNoa').val())
		                }) + ";" + r_accy + "_" + r_cno, 'trans', "95%", "95%", m_print);
			}

			function btnOk() {
				$('#txtTrandate').val($.trim($('#txtTrandate').val()));
				if ($('#txtTrandate').val().length == 0 || !q_cd($('#txtTrandate').val())) {
                    alert(q_getMsg('lblTrandate') + '錯誤。');
                    Unlock(1);
                    return;
                }
                
				sum();
				if(q_cur ==1){
					$('#txtWorker').val(r_name);
				}else if(q_cur ==2){
					$('#txtWorker2').val(r_name);
				}else{
					alert("error: btnok!");
				}
				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtTrandate').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_trans') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], '', '', 2);
			}
			
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
			}

			function refresh(recno) {
				_refresh(recno);
				refreshBbs();
			}
			function refreshBbs(){
				switch(q_getPara('sys.project').toUpperCase()){
					default:
						break;
				}
				$('#textMile').val(q_sub(q_float('txtEmile'),q_float('txtBmile')));
				if(q_float('txtOil')==0)
					$('#textAvg').val('');
				else
					$('#textAvg').val(round(q_div(q_float('textMile'),q_float('txtOil')),4));
				
				for(var i=0;i<q_bbsCount;i++){
					if(q_cur==1 || q_cur==2){
						$('#btnFile_'+i).attr('disabled','disabled');
						$('#btnUpload_'+i).attr('disabled','disabled');
					}else if($('#txtNoq_'+i).val().length>0){
						$('#btnFile_'+i).removeAttr('disabled');
						$('#btnUpload_'+i).removeAttr('disabled');
					}
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(t_para){
					$('#txtDatea').datepicker('destroy');
					$('#txtTrandate').datepicker('destroy');
					$('#btnOrde').attr('disabled','disabled');
				}else{
					$('#txtDatea').datepicker();
					$('#txtTrandate').datepicker();
					$('#btnOrde').removeAttr('disabled');
				}
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
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					default:
						break;
				}
			}
			function q_popPost(id) {
				switch(id){
					case 'txtProductno_':
						var n = b_seq;
						refreshWV(n);
						break;
					default:
						break;
				}
			}
			
		</script>
		
		<style type="text/css">
			#dmain {
				overflow: auto;
				width: 1600px;
			}
			.dview {
				float: left;
				width: 350px;
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
				width: 800px;
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
				width: 12%;
			}
			.tbbm .tr2, .tbbm .tr3, .tbbm .tr4 {
				background-color: #FFEC8B;
			}
			.tbbm .tdZ {
				width: 1%;
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
			}
			.dbbs {
				width: 1700px;
			}
			.dbbt {
				width: 2000px;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			select {
				font-size: medium;
			}
			
          /*  #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }*/
		</style>
	</head>
	<body 
	ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:80px; color:black;"><a>登錄日期</a></td>
						<td align="center" style="width:100px; color:black;"><a>司機</a></td>
						<td align="center" style="width:100px; color:black;"><a>車牌</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox"/></td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='driver' style="text-align: center;">~driver</td>
						<td id='carno' style="text-align: center;">~carno</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr class="tr0" style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTrandate" class="lbl">交運日期</a></td>
						<td><input type="text" id="txtTrandate" class="txt c1"/></td>
						<td><span> </span><a id="lblDatea" class="lbl">交運日期</a></td>
						<td><input type="text" id="txtDatea" class="txt c1"/></td>
						<td> </td>
						<td><input type="button" id="btnOrde" value="訂單匯入"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCarno" class="lbl">車牌</a></td>
						<td><input type="text" id="txtCarno" class="txt c1"/></td>
						<td><span> </span><a id="lblDriver" class="lbl">司機</a></td>
						<td colspan="2">
							<input type="text" id="txtDriverno" class="txt" style="float:left;width:40%;"/>
							<input type="text" id="txtDriver" class="txt" style="float:left;width:60%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTotal" class="lbl">應收金額</a></td>
						<td><input type="text" id="txtTotal" class="txt c1 num"/></td>
						<td><span> </span><a id="lblTotal2" class="lbl">應付金額</a></td>
						<td><input type="text" id="txtTotal2" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan="5"><input type="text" id="txtMemo" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblBmile" class="lbl">上次里程</a></td>
						<td><input type="text" id="txtBmile" class="txt c1 num"/></td>
						<td><span> </span><a id="lblEmile" class="lbl">本次里程</a></td>
						<td><input type="text" id="txtEmile" class="txt c1 num"/></td>
						<td><span> </span><a id="lblOil" class="lbl">油量</a></td>
						<td><input type="text" id="txtOil" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMile" class="lbl">本日行駛里程</a></td>
						<td><input type="text" id="textMile" class="txt c1 num"/></td>
						<td><span> </span><a id="lblAvg" class="lbl">每公升行駛里程</a></td>
						<td><input type="text" id="textAvg" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text"  class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text"  class="txt c1"/></td>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td colspan="1"><input type="text" id="txtNoa" class="txt c1"/></td>
					</tr>
				</table>
			</div>
			<img id="img" crossorigin="anonymous" style="float:left;display:none;"/> 
		</div>
		<div class='dbbs' >
			<table id="tbbs" class='tbbs'>
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:25px"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:60px;"><a>作業</a></td>
					<td align="center" style="width:200px;"><a>貨主</a></td>
					<td align="center" style="width:100px;"><a>船公司</a></td>
					<td align="center" style="width:200px;"><a>起迄點</a></td>
					<td align="center" style="width:60px;"><a>E／F</a></td>
					<td align="center" style="width:100px;"><a>櫃型</a></td>
					<td align="center" style="width:130px;"><a>櫃號</a></td>
					
					<td align="center" style="width:60px;"><a>應收<br>金額</a></td>
					<td align="center" style="width:60px;"><a>應付<br>金額</a></td>
					<td align="center" style="width:100px;"><a>P／O</a></td>
					<td align="center" style="width:100px;"><a>S／O</a></td>
					<td align="center" style="width:100px;"><a>憑單號碼</a></td>
					<td align="center" style="width:120px;"><a>備註</a></td>
					<td align="center" style="width:150px;"><a>訂單編號</a></td>
					<td style="display:none"> </td>
				</tr>
				<tr class="data" style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input type="text" id="txtNoq.*" style="display:none;"/>
						<input type="text" id="txtCarno.*" style="display:none;"/>
						<input type="text" id="txtDriverno.*" style="display:none;"/>
						<input type="text" id="txtDriver.*" style="display:none;"/>
						<input type="text" id="txtTrandate.*" style="display:none;"/>
						<input type="text" id="txtDatea.*" style="display:none;"/>
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input type="text" id="txtCstype.*" list="listCstype" style="width:95%;text-align: center;"/></td>
					<td>
						<input type="text" id="txtCustno.*" style="float:left;width:30%;"/>
						<input type="text" id="txtComp.*" style="float:left;width:60%;"/>
						<input type="text" id="txtNick.*" style="display:none;"/>
						<input type="button" id="btnCust.*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtBoatno.*" style="display:none;"/>
						<input type="text" id="txtBoat.*" style="float:left;width:95%;"/>
						<input type="button" id="btnBoat.*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtStraddrno.*" style="float:left;width:30%;"/>
						<input type="text" id="txtStraddr.*" style="float:left;width:60%;"/>
						<input type="button" id="btnStraddr.*" style="display:none;"/>
						<input type="text" id="txtEndaddrno.*" style="display:none;float:left;width:30%;"/>
						<input type="text" id="txtEndaddr.*" style="display:none;float:left;width:60%;"/>
						<input type="button" id="btnEndaddr.*" style="display:none;"/>
					</td>
					
					
					<!--td><input type="text" id="txtFill.*" list="listEf" style="width:95%;text-align: center;"/></td-->
					<td><input type="text" id="txtFill.*" style="float:left;width:95%;"/></td>
					<td><input type="text" id="txtCasetype.*" list="listCasetype" style="width:95%;"/></td>
					<td>
						<input type="text" id="txtCaseno.*" style="float:left;width:95%;"/>
						<input type="text" id="txtCaseno2.*" style="float:left;width:95%;"/>
						<input type="text" id="txtMount.*" style="display:none;"/>
					</td>
					<td><input type="text" id="txtTotal.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTotal2.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtPo.*" style="width:95%;"/></td>
					<td><input type="text" id="txtSo.*" style="width:95%;"/></td>
					<td><input type="text" id="txtCustorde.*" style="width:95%;"/></td>
					<td><input type="text" id="txtMemo.*" style="width:95%;"/></td>
					<td><input type="text" id="txtOrdeno.*" style="width:95%;"/></td>
					<td style="display:none">
						<input type="file" id="btnFile.*" style="float:left;width:65%;" multiple/>
						<input type="button" id="btnUpload.*" value="上傳" style="float:left;width:30%;"/>
						<input type="button" id="btnDownload.*" value="下載" style="display:none;"/>
						<input type="text" id="txtSender.*" style="display:none;"/>
						<input type="text" id="txtSaddr.*" style="display:none;"/>
					</td>
				</tr>

			</table>
		</div>
		<datalist id="listUnit"> </datalist>
		<datalist id="listUnit2"> </datalist>
		<datalist id="listCstype"> </datalist>
		<datalist id="listCasetype"> </datalist>
		<datalist id="listEf"> </datalist>
		<input id="q_sys" type="hidden" />
	</body>
</html>
