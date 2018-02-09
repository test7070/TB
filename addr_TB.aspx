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
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
        <script src="css/jquery/ui/jquery.ui.core.js"></script>
        <script src="css/jquery/ui/jquery.ui.widget.js"></script>
        <script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
        <script type="text/javascript">
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }
            isEditTotal = false;
            q_tables = 's';
            var q_name = "addr";
            var q_readonly = ['txtAddr'];
            var q_readonlys = [];
            var bbmNum = [];
            var bbsNum = [['txtCustprice', 10, 3], ['txtTggprice', 10, 3], ['txtDriverprice', 10, 3], ['txtDriverprice2', 10, 3]];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Noa';

            aPop = new Array(['txtStraddrno', 'lblStraddr', 'addr2', 'noa,post', 'txtStraddrno,txtStraddr', 'addr2_b.aspx'],
                             ['txtEndaddrno', 'lblEndaddr', 'addr2', 'noa,post', 'txtEndaddrno,txtEndaddr', 'addr2_b.aspx'],
                             ['txtProductno', 'lblProductno', 'ucc', 'noa,product', 'txtProductno,txtProduct', 'ucc_b.aspx'],
                             ['txtSalesno_', '', 'sss', 'noa,namea', 'txtSalesno_,txtSales_', 'sss_b.aspx'],
                             ['txtCustno_', 'btnCust_', 'cust', 'noa,nick', 'txtCustno_,txtCust_', 'cust_b.aspx']);
            $(document).ready(function() {
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
            }

            function mainPost() {
                q_getFormat();
                q_mask(bbmMask);
                bbsMask = [['txtDatea', r_picd]];
                 //上方插入空白行
                $('#lblTop_row').mousedown(function(e) {
                    if(e.button==0){
                        mouse_div=false;
                        q_bbs_addrow(row_bbsbbt,row_b_seq,0);
                    }
                 });
                //下方插入空白行
                $('#lblDown_row').mousedown(function(e) {
                    if(e.button==0){
                        mouse_div=false;
                        q_bbs_addrow(row_bbsbbt,row_b_seq,1);
                    }
                });
                $('#lblTop_row').hover(function(e){
                    $(this).css('background','orange');
                },function(e){
                    $(this).css('background','white');
                });
                $('#lblDown_row').hover(function(e){
                    $(this).css('background','orange');
                },function(e){
                    $(this).css('background','white');
                });
    
                $('#txtStraddrno').change(function() {
                     change_addr();
                });
                
                $('#txtStraddrno').change(function() {
                     change_addr();
                }); 
            }
            
            function change_addr(){
                var t_str,t_end;
                t_str=$('#txtStraddr').val();
                t_end=$('#txtEndaddr').val();
                if(!emp($('#txtStraddr').val()) && !emp($('#txtEndaddr').val())){
                      $('#txtAddr').val(t_str+'-'+t_end);
                }else if(!emp($('txtEndaddr').val())){
                      $('#txtAddr').val(t_end);
                }else{
                      $('#txtAddr').val(t_str);
                }
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
                switch (t_name) {
                    case 'z_addr':
                        var as = _q_appendData("authority", "", true);
                        if(as[0] != undefined && (as[0].pr_run=="1" || as[0].pr_run=="true")){
                            q_box("z_addr.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy,'z_addr', "95%", "95%", q_getMsg("popPrint"));
                            return;
                        }
                        q_box("z_addr2.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy,'z_addr2', "95%", "95%", q_getMsg("popPrint"));
                        break;
                    case 'checkAddrno_btnOk':
                        var as = _q_appendData("addr", "", true);
                        if (as[0] != undefined){
                            alert('已存在 '+as[0].noa+' '+as[0].addr);
                            Unlock();
                            return;
                        }else{
                            wrServer($('#txtNoa').val());
                        }
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }
            }
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                Unlock(1);
            }
            function btnOk() {
                Lock(1,{opacity:0});
                $('#txtNoa').val($.trim($('#txtNoa').val()));
                change_addr();       
                if(q_cur==1){
                    t_where="where=^^ noa='"+$('#txtNoa').val()+"'^^";
                    q_gt('addr', t_where, 0, 0, 0, "checkAddrno_btnOk", r_accy);
                }else{
                    wrServer($('#txtNoa').val());
                }
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)
                    return;

                q_box('addr_tb_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
            }

            function bbsAssign() {
                for (var j = 0; j < q_bbsCount; j++) {
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                        $('#btnMinus_' + j).bind('contextmenu',function(e) {
                            e.preventDefault();
                            mouse_div=false;
                            ////////////控制顯示位置
                            $('#div_row').css('top',e.pageY);
                            $('#div_row').css('left',e.pageX);
                            ////////////
                            t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            $('#div_row').show();
                            row_b_seq=b_seq;
                            row_bbsbbt='bbs';
                        });
                    }

                }
                _bbsAssign();
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').focus();
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                $('#txtNoa').attr('readonly', 'readonly').css('color','green').css('background','rgb(237,237,237)');
                $('#txtAddr').focus();
            }

            function btnPrint() {
                if(r_rank>8)
                    q_box("z_addr.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy,'z_addr', "95%", "95%", q_getMsg("popPrint"));
                else
                    q_gt('authority',"where=^^ a.noa='z_addr' and a.sssno='"+r_userno+"'^^", 0, 0, 0, "z_addr", r_accy);
               
            }

            function wrServer(key_value) {
                var i;

                $('#txtNoa').val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['datea']) {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }
            function sum() {
            }

            function refresh(recno) {
                _refresh(recno);
                change_addr();
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
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 500px; 
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
                width: 450px;
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
                width: 20%;
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
                font-size:medium;
            }
            .dbbs {
                width: 1200px;
            }
            .tbbs a {
                font-size: medium;
            }
            
            .num {
                text-align: right;
            }
            input[type="text"],input[type="button"] {
                font-size:medium;
            }
        </style>
    </head>
    <body ondragstart="return false" draggable="false"
    ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
    ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    >   
        <div id="div_row" style="position:absolute; top:300px; left:500px; display:none; width:150px; background-color: #ffffff; ">
            <table id="table_row"  class="table_row" style="width:100%;" border="1" cellpadding='1'  cellspacing='0'>
                <tr>
                    <td align="center" ><a id="lblTop_row" class="lbl btn">上方插入空白行</a></td>
                </tr>
                <tr>
                    <td align="center" ><a id="lblDown_row" class="lbl btn">下方插入空白行</a></td>
                </tr>
            </table>
        </div>

        <!--#include file="../inc/toolbar.inc"-->
        <div id='dmain'>
            <div class="dview" id="dview" >
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
                        <td align="center" style="width:100px; color:black;"><a id='vewNoa'> </a></td>
                        <td align="center" style="width:200px; color:black;"><a id='vewStraddr'> </a></td>
                        <td align="center" style="width:200px; color:black;"><a id='vewEndaddr'> </a></td>
                        <td align="center" style="width:150px; color:black;"><a id='vewProductno'> </a></td>
                    </tr>
                    <tr>
                        <td><input id="chkBrow.*" type="checkbox" /></td>
                        <td style="text-align: center;" id='noa'>~noa</td>
                        <td style="text-align: left;" id='straddr'>~straddr</td>
                        <td style="text-align: left;" id='endaddr'>~endaddr</td>
                        <td style="text-align: left;" id='product'>~product</td>
                    </tr>
                </table>
            </div>
            <div class='dbbm'>
                <table class="tbbm"  id="tbbm">
                    <tr>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td class="tdZ"> </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblNoa' class="lbl"> </a></td>
                        <td colspan="2"><input id="txtNoa" type="text" class="txt c1" /></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblStraddr' class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtStraddrno" type="text" style="float:left; width:40%;"/>
                            <input id="txtStraddr" type="text" style="float:left; width:60%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblEndaddr' class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtEndaddrno" type="text" style="float:left; width:40%;"/>
                            <input id="txtEndaddr" type="text" style="float:left; width:60%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblProductno' class="lbl btn"> </a></td>
                        <td colspan="3">
                            <input id="txtProductno" type="text" style="float:left; width:40%;"/>
                            <input id="txtProduct" type="text" style="float:left; width:60%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblAddr' class="lbl"> </a></td>
                        <td colspan="3"><input id="txtAddr" type="text" class="txt c1" /></td>
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
                    <td align="center" style="width:80px;"><a id='lblDatea_s'> </a></td>
                    <td align="center" style="width:140px;"><a id='lblCust_tb'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblDriverunit_tb'> </a><br>計價方式</td>
                    <td align="center" style="width:80px;"><a id='lblDriverprice_tb'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblDriverunit2_tb'> </a><br>計價方式</td>
                    <td align="center" style="width:80px;"><a id='lblDriverprice2_tb'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblCustunit_tb'> </a><br>計價方式</td>
                    <td align="center" style="width:80px;"><a id='lblCustprice_tb'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblTggunit_tb'> </a><br>計價方式</td>
                    <td align="center" style="width:80px;"><a id='lblTggprice_tb'> </a></td>
                    <td align="center" style="width:150px;"><a id='lblMemo_s'> </a></td>
                </tr>
                <tr  style='background:#cad3ff;'>
                    <td align="center">
                    <input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
                    <input id="txtNoq.*" type="text" style="display: none;" />
                    </td>
                    <td><input type="text" id="txtDatea.*" style="width:95%;"/></td>
                    <td>
                        <input type="button" id="btnCust.*" style="width:1%;float:left;"/>
                        <input type="text" id="txtCustno.*" style="width:40%;float:left;"/>
                        <input type="text" id="txtCust.*" style="width:40%;float:left;"/>
                    </td>
                    <td><input type="text" id="txtDriverunit.*" style="width:95%;"/></td>
                    <td><input type="text" id="txtDriverprice.*" style="width:95%;text-align:right;"/></td>
                    <td><input type="text" id="txtDriverunit2.*" style="width:95%;"/></td>
                    <td><input type="text" id="txtDriverprice2.*" style="width:95%;text-align:right;"/></td>
                    <td><input type="text" id="txtCustunit.*" style="width:95%;"/></td>
                    <td><input type="text" id="txtCustprice.*" style="width:95%;text-align:right;"/></td>
                    <td><input type="text" id="txtTggunit.*" style="width:95%;"/></td>
                    <td><input type="text" id="txtTggprice.*" style="width:95%;text-align:right;"/></td>
                    <td><input type="text" id="txtMemo.*" style="width:95%;"/></td>
                </tr>
            </table>
        </div>
        <input id="q_sys" type="hidden" />
    </body>
</html>
