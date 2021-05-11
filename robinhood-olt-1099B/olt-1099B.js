// ==UserScript==
// @name         read csv
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.olt.com/2020/oltproc/olt_capgainlossNec.php
// @match        https://www.olt.com/2020/oltproc/olt_capgainlossdone.php*
// @match        https://www.olt.com/2020/oltproc/olt_capgainloss.php
// @match        https://www.olt.com/2020/oltproc/olt_welcome_page.php
// @icon         https://www.google.com/s2/favicons?domain=olt.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    //default to add more 1099-B when back to capgainlosNec page
    if($('#more1').length){
        $('#more1')[0].checked=true
    }
    //for capgainlossdone page
    //hardcode as only using one brokerage
    if($('#payerin_id').length){
        $('#payerin_id')[0].selectedIndex=1
    }
    //for capgainloss page
    if($('#f1099b_nec_type_of_incme2').length){
        //as f-1 student alway not connected US business
        $('#f1099b_nec_type_of_incme2')[0].checked=true
    }
    if($('#pnlWagSch').length){
        $('#pnlWagSch')[0].style.display="block"
        if($('#f1099b_nec_tax_rateID').length){
            //30% tax rate
            $('#f1099b_nec_tax_rateID')[0].value=30
        }
    }

    var importCnt=$('#mytable .row-striped').length
    //add file button to sidebar
    var input = document.createElement('div')
    input.class = "nav-primary"
    input.innerHTML += "<input type='file' id='csv' name='files[]' multiple />"
    var logout = $('#OLTLiBackToAccount')[0];
    //add duplicate(or move?) button simply prevent from accidentally clicking logout
    $('#OLTLiBackToAccount')[0].parentNode.appendChild($('#OLTLiBackToAccount')[0])
    $('#OLTLiBackToAccount')[0].parentNode.appendChild(input)
    var output = document.createElement('div')
    output.id = "out"
    output.class = "nav-primary"
    output.innerHTML = "Now " + importCnt+" transactions imported<br />Next you should select " + (++importCnt)+".csv in next page"
    input.append(output);
    var transaction,column,company,solddate,shareCnt,proceeds,acqdate,basis,column1g
    var fileInput = document.getElementById("csv")

    var readFile = function () {
        var reader = new FileReader();
        reader.onload = function () {
            digest(reader)
            reset()
            var description=shareCnt+" sh. "+company+ " Co."
            fillOutForm(description,acqdate,proceeds,basis,solddate,column1g,true,true)
            //original code used to show content right below the input button(https://stackoverflow.com/questions/29393064/reading-in-a-local-csv-file-in-javascript)
            //document.getElementById('out').innerHTML = reader.result;
            //setTimeout(reset,2000)
        };
        // start reading the file. When it is done, calls the onload event defined above.
        reader.readAsBinaryString(fileInput.files[0]);
    };

    fileInput.addEventListener('change', readFile);
    // Your code here...
    function digest(reader){
        console.log("digest being called")
        transaction=reader.result
        column=transaction.split(" ")
        console.log(column)
        company=column[0]
        solddate=column[1].split("/")
        shareCnt=column[2]
        proceeds=column[3].replace(/,/g, '')
        acqdate=column[4].split("/")
        basis=column[5].replace(/,/g, '')
        //console.log(column1g.length)
        //console.log(column1g.trim().length)
        //unforunately, last column seems having a line break character at the end, need to trim it then compare
        column1g=column[6].trim()
    }
    function fillOutForm(description,acqdate,proceeds,basis,solddate,column1g,isShortTerm,isGross){
        console.log("fillOutForm being called")
        $('#comment')[0].innerHTML=description
        console.log(acqdate)
        if(acqdate.length==3){
            $('#acqmonthBID')[0].value=acqdate[0]
            $('#acqdayBID')[0].value=acqdate[1]
            $('#acqyearBID')[0].value=acqdate[2].length==2?"20"+acqdate[2]:acqdate[2]
        }else{
            $('#various_indB')[0].checked=true
        }
        $('#sell_priceB')[0].value=proceeds

        $('#buy_priceB')[0].value=basis

        $('#soldmonthBID')[0].value=solddate[0]
        $('#solddayBID')[0].value=solddate[1]
        $('#soldyearBID')[0].value=solddate[2].length==2?"20"+solddate[2]:solddate[2]

        $('#wash_sale_dis_amtS')[0].value=column1g!="..." ? column1g : 0;

        $('#term_indBS')[0].checked=isShortTerm

        $('#rprt_grossnet_proc_ind1')[0].checked=isGross

    }
    function reset(){
        console.log("reset being called")
        fillOutForm("",["","",""],"","",["","",""],"","","")
        $('#various_indB')[0].checked=""
    }
})();
