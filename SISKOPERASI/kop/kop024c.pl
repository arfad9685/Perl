sub kop024c {

genfunckop::validasi_akses_kop($s3s[11], $in{ss});

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>
      <br/> &nbsp;   <br/>
     <table width=100% border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> TAMBAH TRANSAKSI MINUS</h2> </td>
     <td align=left width=150>&nbsp; </td>
     </tr>
     </table>
     <br/>
~;

($month,$day,$year,$weekday) = &jdate(&today());

if($in{simpan})
{
   $in{ket}=~ s/\'/\ /g;
   $in{ket}=~ s/\"/\ /g;
   $in{jml}=~ s/\'/\ /g;
   $in{jml}=~ s/\"/\ /g;

   $wrn='';
   if (!($in{dt})) { $wrn.="<li>Tgl Transaksi</li>"; }
   if (!($in{ket})) { $wrn.="<li>Keterangan</li>"; }
   if (!($in{jml})) { $wrn.="<li>Jumlah</li>"; }

   if ($wrn ne "" )
   {  $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan format yang benar: $wrn</div><br/>";
   }
   else
   {  $periode = genfunckop::getPeriodeKop($in{dt});

      $q1 = $dbk->do("INSERT INTO Minus (periode, dttransaksi, keterangan, jumlah,  OPRCREATE) VALUES
                ('$periode','$in{dt}','$in{ket}','$in{jml}','$s3s[0]');");
      if($q1!=0)
      { print qq~<div class=warning_ok> Sukses Tambah Transaksi Minus </div> ~; }
      else
      { print qq~<div class=warning_not_ok> GAGAL Tambah Transaksi Minus : 1=$q1 </div> ~;  }
   }
}
else
{

print qq~<form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop024c>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Transaksi </td>
    <td class="hurufcol" ><input class='huruf1' name="dt" type="text" id="dt" size="12" maxlength="12" value="$in{dt}"   onChange="hitungDurasi()"/>
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
       </script>
    </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Keterangan </td>
    <td class="hurufcol"> <input type=text name=ket id=ket value="$in{ket}" class=huruf1 size=55 maxlength="50"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Jumlah </td>
    <td class="hurufcol"> <input type=text name=jml id=jml value="$in{jml}" class=huruf1 size=10 maxlength="10" style="text-align: right"></td>
  </tr>
   <tr>
    <td colspan=2 align=center><input type='submit' name='simpan' value='Simpan'> </td>
  </tr>
</table>
</form>    ~;
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

