sub kop023 {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Transaksi Plus', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

print qq~
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
   .hoverTable tr{
		background: #ffffff;
	}
    .hoverTable tr:hover {
          background-color: #ffff99;
    }
    .hoverTable td:hover {
          border: 2px solid red;
    }
</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"950px",
      height:"95%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>

     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=right width=50>&nbsp;
      </td>
     <td align=center> <h2 class="hurufcol">TRANSAKSI PLUS </h2> </td>
      <td align=right width=50>~;
if ($s3s[11] eq 'S')
{     print qq~
      <a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop023c&ss=$in{ss}'><img src='/images/add.png'></a>
       ~;
}     print qq~
      </td>
     </tr>
     </table>
~;

print qq~
<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop023>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Transaksi </td>
    <td class="hurufcol" ><input class='huruf1' name="dt" type="text" id="dt" size="12" maxlength="12" value="$in{dt}" />
       <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dt",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger3"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script> s/d <input class='huruf1' name="dt2" type="text" id="dt2" size="12" maxlength="12" value="$in{dt2}" />
       <img src="/jscalendar/img.gif" id="trigger4" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dt2",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger4"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script>
    </td>
    </tr>
</table><input type='submit' name='search' value='Search'>
</form>
~;

if($in{reciddel})
{
     $q1 = $dbk->do("update Plus set batal='Y', oprupdate='$s3s[0]' where recid = '$in{reciddel}';");

     if($q1!=0)
     { print qq~<div class=warning_ok>Sukses Batalkan Transaksi Plus </div>~;}
     else
     { print qq~<div class=warning_ok>Gagal Batalkan Transaksi Plus </div>~;}
}

if($in{search})
{    $subq="";
     if($in{dt}) {  $subq.=" and dttransaksi>='$in{dt}' "; }
     if($in{dt2}) {  $subq.=" and dttransaksi<='$in{dt2}' "; }
     if($subq){ $subq=substr $subq,5; $subq="WHERE $subq"; }

     print qq~
<script type="text/javascript">
function toDelete(n)
{  var result = confirm("Yakin Batalkan Transaksi Plus ?");
        if (result==true)
        { with(document.ps)
          {  reciddel.value = n;
             submit();
          }
        }
}
</script>

<form action="/cgi-bin/siskop.cgi" method="post" name="ps">
  <input type=hidden name=ss value="$in{ss}">
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=pages value='kop023'>
  <input type=hidden name=reciddel value=''>

     <table border=0 cellspacing=0 cellpadding=2 width=1000>
        <tr bgcolor=$dark height=20 class=hurufcol>
          <td align=center width=30><b>No</b></td>
          <td align=center width=80><b>Periode</b></td>
          <td align=center width=80><b>Tgl Transaksi</b></td>
          <td align=center width=120><b>Keterangan</b></td>
          <td align=center width=80><b>Jumlah</b></td>
          <td align=center width=30><b>Batal</b></td>
        </tr> ~;
        
     $query = $dbk->prepare("select periode, dttransaksi, keterangan, jumlah, batal, recid from plus $subq order by dttransaksi, jumlah ");
     $query->execute(); $no=1;   $total=0;
     while (@rec = $query->fetchrow_array())
     { $dt = genfuncpyl::mdytodmy($rec[1]);
       $jml = genfuncpyl::ribuan($rec[3]);
       if($rec[4] eq 'N'){ $total+=$rec[3]; }
       
       if($rec[4] eq 'N' and $s3s[11] eq 'S')
       { $btn = "<input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"toDelete('$rec[5]');\">";
       }
       else { $btn = $rec[4]; }
       
       if($no%2==1){ $bg=$colcolor; }
       else { $bg=$colcolor2; }

       if($rec[8] eq 'Y'){ $bg="dddddd"; }

       print qq~
       <tr bgcolor=$bg class=hurufcol>
          <td align=center>$no</td>
          <td align=center>$rec[0]</td>
          <td align=center>$dt</td>
          <td >$rec[2]</td>
          <td align=right>$jml</td>
          <td align=center>$btn</td>
       </tr>   ~;
       $no++;
     }
     
     $txttotal = genfuncpyl::ribuan($total);
     print qq~<tr bgcolor=$dark class=hurufcol height=20>
          <td align=center colspan=4><b> TOTAL </b> </td>
          <td align=right><b>$txttotal</b></td>
          <td>&nbsp; </td>
       </tr>
     </table>
     </form> ~;
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

