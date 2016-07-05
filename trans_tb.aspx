<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
    <head>
        <title> </title>
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
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            var q_name = "trans";
            var q_readonly = ['txtNoa','txtOrdeno','txtWorker','txtWorker2','txtTotal','txtTotal2'];
            var bbmNum = [['txtInmount',10,3,1],['txtPton',10,3,1],['txtPrice',10,3,1],['txtTotal',10,0,1],['txtOutmount',10,3,1],['txtPton2',10,3,1],['txtPrice2',10,3,1],['txtPrice3',10,3,1],['txtDiscount',10,3,1],['txtTotal2',10,0,1]];
            var bbmMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            q_desc = 1;
            q_xchg = 1;
            brwCount2 = 15;
            aPop = new Array(['txtStraddrno','lblStraddr_tb','addr2','noa,addr','txtStraddrno,txtStraddr','addr2_b.aspx']
                ,['txtEndaddrno','lblEndaddr_tb','addr2','noa,addr','txtEndaddrno,txtEndaddr','addr2_b.aspx']
                ,['txtUccno','lblUcc','ucc','noa,product','txtUccno,txtProduct','ucc_b.aspx']
                ,['txtCustno', 'lblCust', 'cust', 'noa,comp,nick', 'txtCustno,txtComp,txtNick', 'cust_b.aspx']
                ,['txtDriverno', 'lblDriver', 'driver', 'noa,namea', 'txtDriverno,txtDriver', 'driver_b.aspx']
                ,['txtCarno', 'lblCarno', 'car2', 'a.noa,driver,driverno', 'txtCarno,txtDriver,txtDriverno', 'car2_b.aspx']
                ,['txtBoatno', 'lblBoat', 'boat', 'noa,boat', 'txtBoatno,txtBoat', 'boat_b.aspx']);
           
            function sum() {
                if(q_cur!=1 && q_cur!=2)
                    return;
                var t_price = q_float('txtPrice');
                var t_price2 = q_float('txtPrice2');
                var t_price3 = q_float('txtPrice3');
                var t_mount = q_add(q_float('txtInmount'),q_float('txtPton'));
                var t_mount2 = q_add(q_float('txtOutmount'),q_float('txtPton2'));
                var t_total = round(q_mul(t_price,t_mount),0);
                var t_total2 = round(q_mul(q_mul(q_add(t_price2,t_price3),t_mount2),q_float('txtDiscount')),0);
                $('#txtMount').val(q_trv(t_mount));
                $('#txtMount2').val(q_trv(t_mount2));
                $('#txtTotal').val(q_trv(t_total));
                $('#txtTotal2').val(q_trv(t_total2));
            }
            
            function currentData() {
            }
            currentData.prototype = {
                data : [],
                /*新增時複製的欄位*/
                include : ['txtDatea', 'txtTrandate','txtCarno','txtDriverno','txtDriver'
                    ,'txtCustno','txtComp','txtNick','cmbCalctype','cmbCarteamno','txtStraddrno','txtStraddr','txtEndaddrno','txtEndaddr'
                    ,'txtUccno','txtProduct','txtInmount'
                    ,'txtOutmount','txtPo','txtCustorde','txtUnit','txtUnit2'],
                /*記錄當前的資料*/
                copy : function() {
                    this.data = new Array();
                    for (var i in fbbm) {
                        var isInclude = false;
                        for (var j in this.include) {
                            if (fbbm[i] == this.include[j]) {
                                isInclude = true;
                                break;
                            }
                        }
                        if (isInclude) {
                            this.data.push({
                                field : fbbm[i],
                                value : $('#' + fbbm[i]).val()
                            });
                        }
                    }
                },
                /*貼上資料*/
                paste : function() {
                    for (var i in this.data) {
                        $('#' + this.data[i].field).val(this.data[i].value);
                    }
                }
            };
            var curData = new currentData();
            
            function transData() {
            }
            transData.prototype = {
                calctype : new Array(), 
                isTrd : null,
                isTre : null,
                isoutside : null,            
                refresh : function(){
                    $('#lblPrice2').hide();
                    $('#txtPrice2').hide();
                    $('#lblPrice3').hide();
                    $('#txtPrice3').hide();
                    for(var i in this.calctype){
                        if(this.calctype[i].noa == $('#cmbCalctype').val()){
                            if(this.calctype[i].isoutside){
                                $('#lblPrice3').show();
                                $('#txtPrice3').show();
                            }else{
                                $('#lblPrice2').show();
                                $('#txtPrice2').show();
                            }
                        }
                    }
                    
                },
                calctypeChange : function(){
                    for(var i in this.calctype){
                        if(this.calctype[i].noa == $('#cmbCalctype').val()){
                            $('#txtDiscount').val(q_trv(this.calctype[i].discount));     
                            this.isoutside = this.calctype[i].isoutside;                            
                        }
                    }
                    this.priceChange();
                },
                priceChange : function(){
                    var t_custno = $.trim($('#txtCustno').val());
                    var t_straddrno = $.trim($('#txtStraddrno').val());
                    var t_endaddrno = $.trim($('#txtEndaddrno').val());
                    var t_productno = $.trim($('#txtUccno').val());
                    var t_date = $.trim($('#txtTrandate').val());
                    var t_unit = $.trim($('#txtUnit').val());
                    
                    t_where = "a.custno='"+t_custno+"' and b.straddrno='"+t_straddrno+"' and b.endaddrno='"+t_endaddrno+"' and b.productno='"+t_productno+"' and a.datea<='"+t_date+"' and a.custunit='"+t_unit+"'";
                    q_gt('addr_tb', "where=^^"+t_where+"^^", 0, 0, 0, 'getPrice_cust');
                },
                checkData : function(){
                    this.isTrd = false;
                    this.isTre = false;
                    this.isoutside = false;
                    for(var i in this.calctype){
                        if(this.calctype[i].noa == $('#cmbCalctype').val()){
                            this.isoutside = this.calctype[i].isoutside;
                        }
                    }
                    $('#txtDatea').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtTrandate').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    
                    $('#txtCustno').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtComp').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtStraddrno').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtStraddr').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtInmount').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtPton').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtPrice').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    
                    $('#txtCarno').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtDriverno').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtDriver').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtOutmount').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtPton2').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtPrice2').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtPrice3').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtDiscount').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#txtTolls').attr('readonly','readonly').css('color','green').css('background','rgb(237,237,237)');
                    $('#cmbCalctype').attr('disabled','disabled');
                    $('#cmbCarteamno').attr('disabled','disabled');
                    if($('#txtOrdeno').val().length>0){
                        //轉來的一律不可改日期
                    }else{
                        var t_tranno = $.trim($('#txtNoa').val());
                        var t_trannoq = $.trim($('#txtNoq').val());
                        var t_datea = $.trim($('#txtDatea').val());
                        if(q_cur==2 && (t_tranno.length==0 || t_trannoq.length==0 || t_datea.length==0)){
                            alert('資料異常。 code:1');
                        }else{
                            //檢查是否已立帳
                            q_gt('view_trds', "where=^^ tranno='"+t_tranno+"' and trannoq='"+t_trannoq+"' ^^", 0, 0, 0, 'checkTrd_'+t_tranno+'_'+t_trannoq+'_'+t_datea,r_accy);
                        }
                    }
                }
           };
            trans = new transData();
                
            $(document).ready(function() {
                bbmKey = ['noa'];
                q_brwCount();
                q_gt('calctype2', '', 0, 0, 0, 'transInit1');
            });
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(0);
            }

            function mainPost() {
                q_modiDay= q_getPara('sys.modiday2');  /// 若未指定， d4=  q_getPara('sys.modiday'); 
                $('#btnIns').val($('#btnIns').val() + "(F8)");
                $('#btnOk').val($('#btnOk').val() + "(F9)");
                
                bbmMask = [['txtDatea', r_picd],['txtTrandate', r_picd]];
                q_mask(bbmMask);
                q_cmbParse("cmbCstype",' ,領,交,送');
                q_cmbParse("cmbCasetype", "20'',40''");
                
                $("#cmbCalctype").focus(function() {
                    /*var len = $("#cmbCalctype").children().length > 0 ? $("#cmbCalctype").children().length : 1;
                    $("#cmbCalctype").attr('size', len + "");
                    $(this).data('curValue',$(this).val());*/
                }).blur(function() {
                    //$("#cmbCalctype").attr('size', '1');
                }).change(function(e){
                    trans.refresh();
                    trans.calctypeChange();
                }).click(function(e){
                    if($(this).data('curValue')!=$(this).val()){
                        trans.refresh();
                        trans.calctypeChange();
                    }
                    $(this).data('curValue',$(this).val());
                });
                //櫃號異常就變色
                $('#txtCaseno').change(function(e){
                    $(this).css('color',$.trim($(this).val()).length==0||checkCaseno($.trim($(this).val()))?'black':'darkred');
                });
                $('#txtCaseno2').change(function(e){
                    $(this).css('color',$.trim($(this).val()).length==0||checkCaseno($.trim($(this).val()))?'black':'darkred');
                });
                $('#txtPrice').change(function(){
                    sum();
                });
                $('#txtPrice2').change(function(){
                    sum();
                });
                $('#txtPrice3').change(function(){
                    sum();
                });
                $('#txtDiscount').change(function(){
                    sum();
                });
                $('#txtInmount').change(function(){
                    sum();
                });
                $('#txtPton').change(function(){
                    sum();
                });
                $('#txtOutmount').change(function(){
                    sum();
                });
                $('#txtPton2').change(function(){
                    sum();
                });
                $('#txtBmiles').change(function(){
                    sum();
                });
                $('#txtEmiles').change(function(){
                    sum();
                });
                $('#txtUnit').change(function(e){
                    trans.priceChange();
                });
                $('#txtUnit2').change(function(e){
                    trans.priceChange();
                });
                $('#txtTrandate').change(function(e){
                    trans.priceChange();
                });
                $('#txtFill').change(function(e){
                    $(this).val($(this).val().toUpperCase()); 
                });
                $('#txtIo').change(function(e){
                    $(this).val($(this).val().toUpperCase()); 
                });
                q_xchgForm();
            }

            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
            }

            function q_gtPost(t_name) {
                switch (t_name) { 
                    case 'getPrice_driver':
                        var t_price = 0;
                        var as = _q_appendData("addrs", "", true);
                        if(as[0]!=undefined){
                            t_price = as[0].driverprice;
                        }
                        $('#txtPrice2').val(t_price);
                        $('#txtPrice3').val(0);
                        
                        sum();
                        break; 
                    case 'getPrice_driver2':
                        var t_price = 0;
                        var as = _q_appendData("addrs", "", true);
                        if(as[0]!=undefined){
                            t_price = as[0].driverprice2;
                        }
                        $('#txtPrice2').val(0);
                        $('#txtPrice3').val(t_price);
                        
                        sum();
                        break;    
                    case 'getPrice_cust':
                        var t_price = 0;
                        var as = _q_appendData("addrs", "", true);
                        if(as[0]!=undefined){
                            t_price = as[0].custprice;
                        }
                        $('#txtPrice').val(t_price);
                        
                        var t_straddrno = $.trim($('#txtStraddrno').val());
                        var t_endaddrno = $.trim($('#txtEndaddrno').val());
                        var t_productno = $.trim($('#txtUccno').val());
                        var t_date = $.trim($('#txtTrandate').val());
                        var t_unit = $.trim($('#txtUnit2').val());
                        if(trans.isoutside){
                            t_where = "b.straddrno='"+t_straddrno+"' and b.endaddrno='"+t_endaddrno+"' and b.productno='"+t_productno+"' and a.datea<='"+t_date+"' and a.driverunit2='"+t_unit+"'";
                            q_gt('addr_tb', "where=^^"+t_where+"^^", 0, 0, 0, 'getPrice_driver2');
                        }else{
                            t_where = "b.straddrno='"+t_straddrno+"' and b.endaddrno='"+t_endaddrno+"' and b.productno='"+t_productno+"' and a.datea<='"+t_date+"' and a.driverunit='"+t_unit+"'";
                            q_gt('addr_tb', "where=^^"+t_where+"^^", 0, 0, 0, 'getPrice_driver');
                        }
                        break;
                    case 'transInit1':
                        var as = _q_appendData("calctypes", "", true);
                        var t_item = "";
                        if(as[0]!=undefined){
                            for ( i = 0; i < as.length; i++) {
                                t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + as[i].noq + '@' + as[i].typea;
                                trans.calctype.push({
                                    noa : as[i].noa + as[i].noq,
                                    typea : as[i].typea,
                                    discount : as[i].discount,
                                    discount2 : as[i].discount2,
                                    isoutside : as[i].isoutside.length == 0 ? false : (as[i].isoutside == "false" || as[i].isoutside == "0" || as[i].isoutside == "undefined" ? false : true)
                                });
                            }
                            q_cmbParse("cmbCalctype", t_item);
                        }
                        if(abbm[q_recno]!=undefined)
                            $("#cmbCalctype").val(abbm[q_recno].calctype);  
                       
                        q_gt('carteam', '', 0, 0, 0, 'transInit2');
                        break;
                    case 'transInit2':
                        var as = _q_appendData("carteam", "", true);
                        var t_item = "";
                        if(as[0]!=undefined){
                            for ( i = 0; i < as.length; i++) {
                                t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].team;
                            }
                            q_cmbParse("cmbCarteamno", t_item);
                        }
                        if(abbm[q_recno]!=undefined)
                            $("#cmbCarteamno").val(abbm[q_recno].carteamno);  
                            
                        q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                    default:
                       
                        break;
                }
            }
            function q_popPost(id) {
                switch(id) {
                    case 'txtStraddrno':
                        trans.priceChange();
                        break;
                    case 'txtEndaddrno':
                        trans.priceChange();
                        break;
                    case 'txtUccno':
                        trans.priceChange();
                        break;
                    default:
                        break;
                }
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)
                    return;
                q_box('trans_tb_s.aspx', q_name + '_s', "550px", "95%", q_getMsg("popSeek"));
            }

            function btnIns() {
                curData.copy();
                _btnIns();
                curData.paste();
                $('#txtNoa').val('AUTO');
                $('#txtNoq').val('001');
                if($('#cmbCalctype').val().length==0){
                    $('#cmbCalctype').val(trans.calctype[0].noa);
                }
                trans.calctypeChange();
                trans.refresh();
                $('#txtDatea').focus();
            }
            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                sum();
            }
            function btnPrint() {
                q_box('z_trans_tb.aspx' + "?;;;;" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
            }
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                Unlock(1);
            }
            function btnOk() {
                Lock(1,{opacity:0});
                //日期檢查
                if($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())){
                    alert(q_getMsg('lblDatea')+'錯誤。');
                    Unlock(1);
                    return;
                }
                if($('#txtTrandate').val().length == 0 || !q_cd($('#txtTrandate').val())){
                    alert(q_getMsg('lblTrandate')+'錯誤。');
                    Unlock(1);
                    return;
                }
                /*if($('#txtDatea').val().substring(0,3)!=r_accy){
                    alert('年度異常錯誤，請切換到【'+$('#txtDatea').val().substring(0,3)+'】年度再作業。');
                    Unlock(1);
                    return;
                }*/
                var t_days = 0;
                var t_date1 = $('#txtDatea').val();
                var t_date2 = $('#txtTrandate').val();
                t_date1 = new Date(dec(t_date1.substr(0, 3)) + 1911, dec(t_date1.substring(4, 6)) - 1, dec(t_date1.substring(7, 9)));
                t_date2 = new Date(dec(t_date2.substr(0, 3)) + 1911, dec(t_date2.substring(4, 6)) - 1, dec(t_date2.substring(7, 9)));
                t_days = Math.abs(t_date2 - t_date1) / (1000 * 60 * 60 * 24) + 1;
                if(t_days>60){
                    alert(q_getMsg('lblDatea')+'、'+q_getMsg('lblTrandate')+'相隔天數不可多於60天。');
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
                var t_date = trim($('#txtDatea').val());
                if (q_cur ==1)
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_trans') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);        
            }

            function wrServer(key_value) {
                var i;
                $('#txtNoa').val(key_value);
                _btnOk(key_value, bbmKey[0], '', '', 2);
            }

            function refresh(recno) {
                _refresh(recno);
                trans.refresh();
                $('#txtCaseno').css('color',$.trim($('#txtCaseno').val()).length==0||checkCaseno($.trim($('#txtCaseno').val()))?'black':'darkred');
                $('#txtCaseno2').css('color',$.trim($('#txtCaseno2').val()).length==0||checkCaseno($.trim($('#txtCaseno2').val()))?'black':'darkred');
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
                if (q_chkClose())
                        return;
                _btnDele();
            }

            function btnCancel() {
                _btnCancel();
            }
            function checkCaseno(string){
                var key ={0:0,1:1,2:2,3:3,4:4,5:5,6:6,7:7,8:8,9:9,A:10,B:12,C:13,D:14,E:15,F:16,G:17,H:18,I:19,J:20,K:21,L:23,M:24,N:25,O:26,P:27,Q:28,R:29,S:30,T:31,U:32,V:34,W:35,X:36,Y:37,Z:38};
                if((/^[A-Z]{4}[0-9]{7}$/).test(string)){
                    var value = 0;
                    for(var i =0;i<string.length-1;i++){
                        value+= key[string.substring(i,i+1)]*Math.pow(2,i);
                    }
                    return Math.floor(q_add(q_div(value,11),0.09)*10%10)==parseInt(string.substring(10,11));
                }else{
                    return false;
                }
            }
        </script>
        <style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 100%; 
                border-width: 0px; 
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #cad3ff;
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
                width: 9%;
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
            .tbbs input[type="text"] {
                width: 98%;
            }
            .tbbs a {
                font-size: medium;
            }
            .num {
                text-align: right;
            }
            .bbs {
                float: left;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            select {
                font-size: medium;
            }
        </style>
    </head>
    <body ondragstart="return false" draggable="false"
    ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
    ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    >
        <!--#include file="../inc/toolbar.inc"-->
        <div id="dmain">
            <div class="dview" id="dview">
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id="vewChk"> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id="vewDatea"> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id="vewTrandate"> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id="vewCarno"> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id="vewDriver"> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id="vewNick"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewStraddr_tb"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewEndaddr_tb"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewFill"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewMount"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewPrice"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewMount2"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewPrice2"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewPrice3"> </a></td>
                        <td align="center" style="width:60px; color:black;"><a id="vewDiscount"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewBoat"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewShip"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewPo"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewCaseno1"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewCaseno2"> </a></td>
                        <td align="center" style="width:120px; color:black;"><a id="vewCustorde"> </a></td>
                    </tr>
                    <tr>
                        <td ><input id="chkBrow.*" type="checkbox"/></td>
                        <td id="datea" style="text-align: center;">~datea</td>
                        <td id="trandate" style="text-align: center;">~trandate</td>
                        <td id="carno" style="text-align: center;">~carno</td>
                        <td id="driver" style="text-align: center;">~driver</td>
                        <td id="nick" style="text-align: center;">~nick</td>
                        <td id="straddr" style="text-align: center;">~straddr</td>
                        <td id="endaddr" style="text-align: center;">~endaddr</td>
                        <td id="fill" style="text-align: center;">~fill</td>
                        <td id="mount" style="text-align: right;">~mount</td>
                        <td id="price" style="text-align: right;">~price</td>
                        <td id="mount2" style="text-align: right;">~mount2</td>
                        <td id="price2" style="text-align: right;">~price2</td>
                        <td id="price3" style="text-align: right;">~price3</td>
                        <td id="discount" style="text-align: right;">~discount</td>
                        <td id="boatname" style="text-align: left;">~boatname</td>
                        <td id="ship" style="text-align: left;">~ship</td>
                        <td id="po" style="text-align: left;">~po</td>
                        <td id="caseno" style="text-align: left;">~caseno</td>
                        <td id="caseno2" style="text-align: left;">~caseno2</td>
                        <td id="custorde" style="text-align: left;">~custorde</td>
                    </tr>
                </table>
            </div>
            <div class="dbbm">
                <table class="tbbm"  id="tbbm">
                    <tr style="height:1px;">
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td class="tdZ"> </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblDatea" class="lbl"> </a></td>
                        <td><input id="txtDatea"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblTrandate" class="lbl"> </a></td>
                        <td><input id="txtTrandate"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblCalctype" class="lbl"> </a></td>
                        <td><select id="cmbCalctype" class="txt c1"> </select></td>
                        <td><span> </span><a id="lblCarteam" class="lbl"> </a></td>
                        <td><select id="cmbCarteamno" class="txt c1"> </select></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblCarno" class="lbl btn"> </a></td>
                        <td><input id="txtCarno"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblDriver" class="lbl btn"> </a></td>
                        <td colspan="2">
                            <input id="txtDriverno"  type="text" style="float:left;width:50%;"/>
                            <input id="txtDriver"  type="text" style="float:left;width:50%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtCustno"  type="text" style="float:left;width:30%;"/>
                            <input id="txtComp"  type="text" style="float:left;width:70%;"/>
                            <input id="txtNick" type="text" style="display:none;"/>
                        </td>
                        <td><span> </span><a id="lblCstype" class="lbl">作業</a></td>
						<td><select id="cmbCstype" class="txt c1"> </select></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblStraddr_tb" class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtStraddrno"  type="text" style="float:left;width:30%;"/>
                            <input id="txtStraddr"  type="text" style="float:left;width:70%;"/>
                        </td>
                        <td><span> </span><a id="lblEndaddr_tb" class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtEndaddrno"  type="text" style="float:left;width:30%;"/>
                            <input id="txtEndaddr"  type="text" style="float:left;width:70%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblUcc" class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtUccno"  type="text" style="float:left;width:30%;"/>
                            <input id="txtProduct"  type="text" style="float:left;width:70%;"/>
                        </td>
                        <td><span> </span><a id="lblFill" class="lbl"> </a></td>
                        <td><input id="txtFill"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblIo" class="lbl"> </a></td>
                        <td><input id="txtIo"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblInmount" class="lbl"> </a></td>
                        <td>
                            <input id="txtInmount"  type="text" class="txt c1 num"/>
                            <input id="txtMount"  type="text" style="display:none;"/>
                        </td>
                        <td><span> </span><a id="lblUnit" class="lbl"> </a></td>
                        <td><input id="txtUnit"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblPton" class="lbl"> </a></td>
                        <td><input id="txtPton"  type="text" class="txt c1 num"/></td>
                        <td><span> </span><a id="lblPrice" class="lbl"> </a></td>
                        <td><input id="txtPrice"  type="text" class="txt c1 num"/></td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td><span> </span><a id="lblTotal" class="lbl"> </a></td>
                        <td>
                            <input id="txtTotal"  type="text" class="txt c1 num"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblOutmount" class="lbl"> </a></td>
                        <td>
                            <input id="txtOutmount"  type="text" class="txt c1 num"/>
                            <input id="txtMount2"  type="text" style="display:none;"/>
                        </td>
                        <td><span> </span><a id="lblUnit2" class="lbl"> </a></td>
                        <td><input id="txtUnit2"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblPton2" class="lbl"> </a></td>
                        <td><input id="txtPton2"  type="text" class="txt c1 num"/></td>
                        <td><span> </span>
                            <a id="lblPrice2" class="lbl"> </a>
                            <a id="lblPrice3" class="lbl"> </a>
                        </td>
                        <td>
                            <input id="txtPrice2"  type="text" class="txt c1 num"/>
                            <input id="txtPrice3"  type="text" class="txt c1 num"/>
                        </td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td><span> </span><a id="lblDiscount" class="lbl"> </a></td>
                        <td><input id="txtDiscount"  type="text" class="txt c1 num"/></td>
                        <td><span> </span><a id="lblTotal2" class="lbl"> </a></td>
                        <td>
                            <input id="txtTotal2"  type="text" class="txt c1 num"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblCaseno" class="lbl"> </a></td>
                        <td colspan="3">
                            <input id="txtCaseno"  type="text" style="float:left;width:50%;"/>
                            <input id="txtCaseno2"  type="text" style="float:left;width:50%;"/>
                        </td>
                        <td><span> </span><a id="lblCasetype" class="lbl"> </a></td>
						<td><select id="cmbCasetype" class="txt c1"> </select></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblBoat" class="lbl btn"> </a></td>
                        <td colspan="2">
                            <input id="txtBoatno"  type="text" style="float:left;width:50%;"/>
                            <input id="txtBoat"  type="text" style="float:left;width:50%;"/>
                        </td>
                        <td><span> </span><a id="lblShip" class="lbl"> </a></td>
                        <td colspan="2"><input id="txtShip" type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblPo" class="lbl"> </a></td>
                        <td colspan="2"><input id="txtPo"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblCustorde" class="lbl"> </a></td>
                        <td colspan="2"><input id="txtCustorde" type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblBmiles" class="lbl"> </a></td>
                        <td><input id="txtBmiles"  type="text" class="txt c1 num"/></td>
                        <td><span> </span><a id="lblEmiles" class="lbl"> </a></td>
                        <td><input id="txtEmiles"  type="text" class="txt c1 num"/></td>
                        <td><span> </span><a id="lblMiles" class="lbl"> </a></td>
                        <td><input id="txtMiles"  type="text" class="txt c1 num"/></td>
                        <td><span> </span><a id="lblGps" class="lbl"> </a></td>
                        <td><input id="txtGps"  type="text" class="txt c1 num"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblMemo" class="lbl"> </a></td>
                        <td colspan="7"><input id="txtMemo"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblNoa" class="lbl"> </a></td>
                        <td>
                            <input id="txtNoa"  type="text" class="txt c1"/>
                            <input id="txtNoq"  type="text" style="display:none;"/>
                        </td>
                        <td><span> </span><a id="lblOrdeno" class="lbl"> </a></td>
                        <td colspan="2"><input id="txtOrdeno"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblWorker" class="lbl"> </a></td>
                        <td><input id="txtWorker" type="text" class="txt c1"/></td>
                        <td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
                        <td><input id="txtWorker2" type="text" class="txt c1"/></td>
                    </tr>
                </table>
            </div>
        </div>
        <input id="q_sys" type="hidden" />
    </body>
</html>
