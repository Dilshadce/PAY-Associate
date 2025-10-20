<cfsetting showdebugoutput="yes" requesttimeout="0">

<cfset hcomid = replace(hcomid,'_i','')>
<cfset counter = 1>

<cfquery name="gettimesheet" datasource="#Replace(dts, '_p', '_i')#">
    SELECT * FROM
    (
        SELECT * FROM 
        (
            SELECT aa.placementno, aa.custno, aa.empname, aa.hrmgr, aa.timesheet, aa.custname, aa.contactperson, aa.ottable,
            b.empno, b.tmonth, b.tyear, b.pdate, b.ot1, b.ot2, b.ot3, b.ot4, b.ot5, b.ot6, b.ot7, b.ot8, b.remarks, 
            b.mgmtremarks, b.workhours, b.ot_type, b.stcol, b.ampm, 
            b.starttime, b.endtime, b.breaktime, b.status, b.created_on, b.updated_on, b.updated_by
            FROM placement aa
            LEFT JOIN #dts#.timesheet b ON aa.placementno = b.placementno
            WHERE b.tmonth = '#url.monthselected#'
            AND b.tyear = '#url.yearselected#'
            AND b.placementno = '#url.placementno#'
        )a
        LEFT JOIN 
        (
            SELECT custno AS 'arucstno', add1, add2, add3, add4, phone FROM arcust
        ) c ON a.custno = c.arucstno
        LEFT JOIN
        (
            SELECT sizeid, desp AS OTdesp FROM icsizeid    
        ) f ON a.ot_type = f.sizeid
        ORDER BY a.empname, a.pdate, a.updated_on DESC
    ) AS sort
    GROUP BY placementno, pdate
</cfquery>

<center><input type="button" id="printbtn" onclick="window.print()" value="Print"></center><br/>

    <cfoutput>
        <html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">

            <head>
                <style type="text/css">
                    @media print
                    {
                        ##non-printable { display: none; }
                        ##endtimesheet { page-break-after: always;}
                        ##printbtn { display: none; }
                        @page { margin: 0; }
                        body { margin: 1.5cm; }
                        ##titlec { margin-top: 3.5cm; }
                    }
                    
                    ##myBtn {
                        display: none; /* Hidden by default */
                        position: fixed; /* Fixed/sticky position */
                        bottom: 20px; /* Place the button at the bottom of the page */
                        right: 30px; /* Place the button 30px from the right */
                        z-index: 99; /* Make sure it does not overlap */
                        border: none; /* Remove borders */
                        outline: none; /* Remove outline */
                        background-color: red; /* Set a background color */
                        color: white; /* Text color */
                        cursor: pointer; /* Add a mouse pointer on hover */
                        padding: 15px; /* Some padding */
                        border-radius: 10px; /* Rounded corners */
                        font-size: 18px; /* Increase font size */
                    }
                    
                    ##myBtn:hover {
                        background-color: ##555; /* Add a dark-grey background on hover */
                    }
                </style>
                
                <script>
                    // When the user scrolls down 20px from the top of the document, show the button
                    window.onscroll = function() {scrollFunction()};

                    function scrollFunction() {
                        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                            document.getElementById("myBtn").style.display = "block";
                        } else {
                            document.getElementById("myBtn").style.display = "none";
                        }
                    }

                    // When the user clicks on the button, scroll to the top of the document
                    function topFunction() {
                        document.body.scrollTop = 0; // For Safari
                        document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
                    }
                </script>
                <meta http-equiv=Content-Type content="text/html; charset=utf-8">
                <meta name=ProgId content=Excel.Sheet>
                <meta name=Generator content="Microsoft Excel 14">
                <link rel=File-List href="Book3_files/filelist.xml">
                <style id="Book1_8828_Styles">
            <!--table
                {mso-displayed-decimal-separator:"\.";
                mso-displayed-thousand-separator:"\,";}
            .xl158828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl658828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:none;
                border-left:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl668828
                {color:black;
                font-size:6.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;
                padding-left:135px;
                mso-char-indent-count:15;}
            .xl678828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:justify;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl688828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:justify;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl698828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl708828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:Fixed;
                text-align:justify;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl718828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:normal;}
            .xl728828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl738828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl748828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl758828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color: black;
                font-size:8.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:justify;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl768828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color: black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:"\@";
                text-align:center;
                vertical-align:bottom;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl778828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color: black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:"Short Time";
                text-align:justify;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl788828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:windowtext;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:Fixed;
                text-align:justify;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl798828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color: black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:Fixed;
                text-align:justify;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl808828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:Fixed;
                text-align:justify;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl818828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl828828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##e77c22;
                mso-pattern:black none;
                white-space:normal;}
            .xl838828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##e77c22;
                mso-pattern:black none;
                white-space:normal;}
            .xl848828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##e77c22;
                mso-pattern:black none;
                white-space:normal;}
            .xl858828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:normal;}
            .xl868828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                background:##e77c22;
                mso-pattern:black none;
                white-space:normal;}
            .xl878828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                background:##e77c22;
                mso-pattern:black none;
                white-space:normal;}
            .xl888828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:bottom;
                border:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:normal;}
            .xl898828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl908828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl918828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl928828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:d;
                text-align:center;
                vertical-align:bottom;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl938828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color: black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:ddd;
                text-align:justify;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl948828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color: black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:"mmm\\-yyyy";
                text-align:left;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:none;
                border-left:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl958828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:##0000CC;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:"mmm\\-yyyy";
                text-align:left;
                vertical-align:top;
                border-top:none;
                border-right:1pt solid windowtext;
                border-bottom:none;
                border-left:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl968828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:##0000CC;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:"mmm\\-yyyy";
                text-align:left;
                vertical-align:top;
                border-top:none;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl978828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:none;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl988828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:none;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl998828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1008828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1018828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1028828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl1038828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:##0000CC;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1048828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1058828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:red;
                font-size:9.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:"Times New Roman", serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:normal;}
            .xl1068828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:red;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:normal;}
            .xl1078828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:top;
                border:1pt solid windowtext;
                background:##e77c22;
                mso-pattern:black none;
                white-space:normal;}
            .xl1088828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1098828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl1108828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1118828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:8.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl1128828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1138828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:13.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl1148828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:15.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl1158828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:normal;}
            .xl1168828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1178828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:9.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border-top:none;
                border-right:1pt solid windowtext;
                border-bottom:none;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            .xl1188828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:none;
                border-left:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1198828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:none;
                border-left:none;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1208828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:none;
                border-bottom:none;
                border-left:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1218828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:1pt solid windowtext;
                border-bottom:none;
                border-left:none;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1228828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1238828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:center;
                vertical-align:middle;
                border-top:none;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1248828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:700;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                background:##D9D9D9;
                mso-pattern:black none;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl1258828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl1268828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl1278828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:nowrap;}
            .xl1288828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:left;
                vertical-align:top;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                mso-protection:unlocked visible;
                white-space:normal;}
            .xl1298828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border-top:1pt solid windowtext;
                border-right:none;
                border-bottom:1pt solid windowtext;
                border-left:none;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1308828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border-top:1pt solid windowtext;
                border-right:1pt solid windowtext;
                border-bottom:1pt solid windowtext;
                border-left:none;
                background:##D9D9D9;
                mso-pattern:black none;
                white-space:nowrap;}
            .xl1318828
                {padding-top:1px;
                padding-right:1px;
                padding-left:1px;
                mso-ignore:padding;
                color:black;
                font-size:10.0pt;
                font-weight:400;
                font-style:normal;
                text-decoration:none;
                font-family:Calibri, sans-serif;
                mso-font-charset:0;
                mso-number-format:General;
                text-align:general;
                vertical-align:bottom;
                border:1pt solid windowtext;
                mso-background-source:auto;
                mso-pattern:auto;
                white-space:nowrap;}
            -->
            </style>
            </head>

            <body>
                <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
                <!--[if !excel]>&nbsp;&nbsp;<![endif]-->
                <!--The following information was generated by Microsoft Excel's Publish as Web
                Page wizard.-->
                <!--If the same item is republished from Excel, all information between the DIV
                tags will be replaced.-->
                <!----------------------------->
                <!--START OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD -->
                <!----------------------------->

                <div id="Book1_8828" align=center x:publishsource="Excel">

                    <table border=0 cellpadding=0 cellspacing=0 width=800 id="titlec" style='border-collapse:collapse;table-layout:fixed;width:800pt'>
                        <col width=34 span=3 style='width:35pt'>
                        <col width=32 span=2 style='width:36pt'>
                        <col width=68 span=2 style='width:60pt'>
                        <col width=64 span=2 style='width:44pt'>
                        <col width=34 span=10 style='width:26pt'>
                        <col width=157 style='mso-width-source:userset;mso-width-alt:5741;width:100pt'>
                        <col width=2 style='mso-width-source:userset;mso-width-alt:73;width:2pt'>
                        <col width=0 style='display:none;mso-width-source:userset;mso-width-alt:2340'>
                        <tr height=20 style='height:15.0pt'>
                            <td height=20 class=xl158828 style='height:15.0pt'></td>
                            <td class=xl668828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                        <tr height=20 style='height:15.0pt'>
                            <td colspan=2 rowspan=3 height=60 class=xl1188828 style='border-right:1pt solid black;border-bottom:1pt solid black;height:45.0pt'>
                                Client
                            </td>
                            <td colspan=9 class=xl1248828 width=384 style='border-left:none;width:288pt'>Company Name &amp; Address</td>
                            <td colspan=13 class=xl898828 width=221 style='width:166pt'>Contact Person &amp; Tel</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                        <tr height=20 style='height:15.0pt'>
                            <td colspan=9 height=20 class=xl1028828 style='height:15.0pt;border-left:none'>#gettimesheet.custname#</td>
                            <td colspan=13 class=xl1288828 width=221 style='border-left:none;width:166pt'>#gettimesheet.contactperson#</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                        <tr height=20 style='height:15.0pt'>
                            <td colspan=9 height=20 class=xl1028828 style='height:15.0pt;border-left:none'>
                                #gettimesheet.add1# #gettimesheet.add2#
                                <cfif gettimesheet.add3 neq "">
                                    <br>
                                </cfif>
                                #gettimesheet.add3# #gettimesheet.add4#
                            </td>
                            <td colspan=13 class=xl1288828 width=221 style='border-left:none;width:166pt'>#gettimesheet.phone#</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                        <tr height=21 style='mso-height-source:userset;height:15.75pt'>
                            <td colspan=2 rowspan=2 height=41 class=xl1188828 style='border-right:1pt solid black;border-bottom:1pt solid black;height:30.75pt'>
                                Staff
                            </td>
                            <td colspan=9 class=xl1248828 width=320 style='border-right:1pt solid black;border-left:none;width:240pt'>Name</td>
                            <td colspan=13 class=xl1248828 width=128 style='border-right:1pt solid black;border-left:none;width:96pt'>Candidate no</td>
                        </tr>
                        <tr height=20 style='height:15.0pt'>
                            <td colspan=9 height=20 class=xl1258828 style='border-right:1pt solid black;height:15.0pt;border-left:none'>
                                #gettimesheet.empname#
                            </td>
                            <td colspan=13 class=xl1288828 width=128 style='border-left:none;width:96pt'>#gettimesheet.empno#</td>
                        </tr>
                        <tr height=21 style='mso-height-source:userset;height:15.75pt'>
                            <td colspan=2 rowspan=2 height=41 class=xl1188828 style='border-right:1pt solid black;border-bottom:1pt solid black;height:30.75pt'>
                                Timesheet<br/> Details
                            </td>
                            <td colspan=9 class=xl1248828 width=320 style='border-right:1pt solid black;border-left:none;width:240pt'>Submitted On</td>
                            <td colspan=13 class=xl1248828 width=128 style='border-right:1pt solid black;border-left:none;width:96pt'>Updated On</td>
                        </tr>
                        <tr height=20 style='height:15.0pt'>
                            <td colspan=9 height=20 class=xl1258828 style='border-right:1pt solid black;height:15.0pt;border-left:none'>
                                #DateTimeFormat(gettimesheet.created_on, 'yyyy-mm-dd hh:nn:ss')#
                            </td>
                            <td colspan=13 class=xl1288828 width=128 style='border-left:none;width:96pt'>
                                <cfif "#gettimesheet.updated_on#" NEQ "0000-00-00 00:00:00">
                                    #DateTimeFormat(gettimesheet.updated_on, 'yyyy-mm-dd hh:nn:ss')# <br/>By #gettimesheet.updated_by#
                                </cfif>
                            </td> 
                        </tr>
                        <tr height=20 style='height:15.0pt'>
                            <td colspan=9 height=20 class=xl1038828 style='height:15.0pt'></td>
                            <td colspan="2" rowspan=2 class=xl1078828 width=64 style='border-top:none;width:48pt'>Normal Hours Worked</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td class=xl718828 style='border-top:none'>&nbsp;</td>
                            <td colspan="5" class=xl718828 width=157 style='border-top:none;border-left:none;width:118pt;'>&nbsp;</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                        <tr height=32 style='height:24.0pt'>
                            <td height=32 class=xl828828 width=64 style='height:24.0pt;border-top:none;width:48pt'>Month</td>
                            <td class=xl848828 width=64 style='border-top:none;border-left:none;width:48pt'>Day</td>
                            <td class=xl858828 width=64 style='border-top:none;border-left:none;width:48pt;background-color: ##e77c22'>Date</td>
                            <td colspan="2" class=xl838828 width=100 style='border-top:none;border-left:none;width:120pt'>Leave<br>(Full Day/AM/PM)</td>
                            <td class=xl838828 width=64 style='border-top:none;border-left:none;width:48pt'>OT Rule</td>
                            <td class=xl838828 width=64 style='border-top:none;border-left:none;width:48pt'>Start Time</td>
                            <td class=xl838828 width=64 style='border-top:none;border-left:none;width:48pt'>End Time</td>
                            <td class=xl868828 width=64 style='border-top:none;border-left:none;width:48pt'>Break(s)</td>
                            <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 1</td>
                            <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 1.5</td>
                            <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 2</td>
                            <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 3</td>
                            <td colspan="2" class=xl878828 width=64 style='border-top:none;width:48pt'>Rest</td>
                            <td colspan="2" class=xl878828 width=64 style='border-top:none;width:48pt'>PH</td>
                            <td colspan="5" class=xl838828 width=157 style='border-top:none;border-left:none;width:118pt'>Remarks</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                        <tr height=32 style='height:24.0pt'>
                            <td height=32 class=xl728828 style='height:24.0pt;border-top:none'>&nbsp;</td>
                            <td colspan=2 class=xl1058828 width=128 style='border-right:1pt solid black;border-left:none;width:96pt'>&nbsp;</td>
                            <td class=xl718828 width=64 style='border-top:none;border-left:none;width:48pt'>&nbsp;</td>
                            <td class=xl718828 width=64 style='border-top:none;border-left:none;width:48pt'>&nbsp;</td>
                            <td class=xl718828 width=64 style='border-top:none;border-left:none;width:48pt'>&nbsp;</td>
                            <td class=xl858828 width=64 style='border-top:none;border-left:none;width:48pt'>hh:mm</td>
                            <td class=xl858828 width=64 style='border-top:none;border-left:none;width:48pt'>hh:mm</td>
                            <td class=xl858828 width=64 style='border-top:none;border-left:none;width:48pt'>hh:mm</td>
                            <td colspan="2" class=xl858828 width=64 style='border-top:none;border-left:none;width:48pt'>(less break)</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>Hour</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>Hour</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>Hour</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>Hour</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>1.0</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>2.0</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>1.0</td>
                            <td class=xl858828 width=36 style='border-top:none;border-left:none;width:26pt'>2.0</td>
                            <td colspan="5" class=xl718828 width=157 style='border-top:none;border-left:none;width:118pt'>&nbsp;</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>

                        <td class=xl158828></td>

                        <cfset startmonth = "">
                        <cfset startcount = 1>
                        <cfset totalhour = 0 >
                        <cfset totalot = 0>
                        <cfset totalot15 = 0>
                        <cfset totalot2 = 0>
                        <cfset totalot3 = 0>
                        <cfset totalotrd1 = 0>
                        <cfset totalotrd2 = 0>
                        <cfset totalotph1 = 0>
                        <cfset totalotph2 = 0>

                        <cfloop query="gettimesheet">
                            <cfset currentdate = gettimesheet.pdate>

                            <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='##f3bd90';" height=20 style='height:12.0pt'>
                                <td height=20 class=xl948828 style='height:12.0pt;border-top:none;<cfif gettimesheet.recordcount eq gettimesheet.currentrow>; border-bottom:1pt solid black;</cfif>'>
                                    <cfif startmonth neq dateformat(currentdate,'Mmm - yyyy')>
                                        #dateformat(currentdate,'Mmm')#
                                        <cfset startmonth = dateformat(currentdate,'Mmm - yyyy')>
                                    </cfif>
                                </td>
                                <td class=xl938828 style='border-top:none'>#dateformat(currentdate,'Ddd')#</td>
                                <td class=xl928828 width=64 style='border-top:none;border-left:none;width:48pt'>#dateformat(currentdate,'dd')#</td>
                                <td class=xl768828 style='border-top:none;border-left:none'>
                                    <cfif gettimesheet.stcol neq "">
                                        #gettimesheet.stcol#
                                    <cfelse>
                                        WD
                                    </cfif>
                                </td>  
                                <td class=xl768828 style='border-top:none;border-left:none'>#gettimesheet.ampm#</td>
                                <td class=xl778828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center;text-overflow: ellipsis;overflow:hidden;white-space: nowrap'>
                                    #gettimesheet.otdesp#
                                </td>
                                <td class=xl778828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center;'>#gettimesheet.starttime#</td>
                                <td class=xl778828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center;'>#gettimesheet.endtime#</td>
                                <td class=xl778828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center;'>
                                    <cfset timenow = createdatetime('2013','1','1','0','0','0')>
                                    #TimeFormat(DateAdd('n',numberformat(gettimesheet.breaktime*60,'.__'),timenow),'HH:MM')#
                                </td>
                                <td colspan="2" class=xl788828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center;'> 
                                    #numberformat(gettimesheet.workhours,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot1,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot2,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot3,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot4,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot5,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot6,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot7,'.__')#
                                </td>
                                <td class=xl798828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                    #numberformat(gettimesheet.ot8,'.__')#
                                </td>
                                <cfset totalhour = totalhour + numberformat(gettimesheet.workhours,'.__')>
                                <cfset totalot = totalot + numberformat(gettimesheet.ot1,'.__')>
                                <cfset totalot15 = totalot15 + numberformat(gettimesheet.ot2,'.__')>
                                <cfset totalot2 = totalot2 + numberformat(gettimesheet.ot3,'.__')>
                                <cfset totalot3 = totalot3 + numberformat(gettimesheet.ot4,'.__')>
                                <cfset totalotrd1 = totalotrd1 + numberformat(gettimesheet.ot5,'.__')>
                                <cfset totalotrd2 = totalotrd2 + numberformat(gettimesheet.ot6,'.__')>
                                <cfset totalotph1 = totalotph1 + numberformat(gettimesheet.ot7,'.__')>
                                <cfset totalotph2 = totalotph2 + numberformat(gettimesheet.ot8,'.__')>
                                <td colspan="5" class=xl758828 style='border-top:none;border-left:none;text-overflow: ellipsis;overflow:visible;white-space:normal'>
									#gettimesheet.remarks#
								</td>
                            </tr>
                        </cfloop>

                        <tr height=20 style='height:12.0pt'>
                            <td colspan=9 height=20 class=xl1158828 width=448 style='border-right:1pt solid black;height:12.0pt;width:336pt'>
                                Total hours for the period (exclude breaks)
                            </td>
                            <td colspan="2" class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalhour,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalot,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalot15,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalot2,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalot3,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalotrd1,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalotrd2,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalotph1,'.__')#
                            </td>
                            <td class=xl808828 width=64 style='border-top:none;border-left:none;width:48pt;text-align:center'>
                                #numberformat(totalotph2,'.__')#
                            </td>
                            <td colspan="5" class=xl708828 width=157 style='border-top:none;border-left:none;width:118pt'>&nbsp;</td>
                            <td class=xl158828></td>
                            <td class=xl158828></td>
                        </tr>
                    </table>
                    <div id="endtimesheet"></div>
                    <cfset counter += 1>
                </div>
                <!----------------------------->
                <!--END OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD-->
                <!----------------------------->
            </body>
            <footer>&nbsp;</footer>
        </html>
    </cfoutput>     