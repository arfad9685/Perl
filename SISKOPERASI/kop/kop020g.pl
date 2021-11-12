sub kop020g {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Generate Iuran', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$bgsukarela2 = "#c9f7ad";
$bgsukarela = "#bfe8a7";
$bgsukareladark = "#a9e884";

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=right width=50><form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=kop020>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
      </td>
     <td align=center> <h2 class="hurufcol">GENERATE IURAN </h2> </td>
      <td align=right width=50>&nbsp;
      </td>
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop020g>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Periode </td>
    <td class="hurufcol" ><select name="periode" class="huruf1" id="periode">
    ~;
($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0".$month, -2;
$minprid=$year."-".$month;
$minprid='2018-01';
$query = $dbk->prepare("select distinct recid from periode where recid >= '$minprid' order by recid asc rows 1 to 5 ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{periode} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] </option>~;
}
print qq~
    </select>
    </td>
    <td><input type='submit' name='gen' value='Generate'> </td>
  </tr>
</table>
</form>    ~;

if($in{gen})
{
 $query = $dbk->prepare("select count(*) from iuran where periode='$in{periode}' ");
 $query->execute();
 @rec = $query->fetchrow_array();
 if($rec[0]>0){ print qq~<div class=warning_not_ok>Periode $in{periode} sudah di-generate ($rec[0] record)</div>~; }
 else
 {
  $query = $dbk->prepare("select a.idlama, jenis, jumlah from anggota a, simpanan s
        where  a.idlama=s.idlama and dtexpired='1/1/2099' and a.aktif='Y'
        order by a.idlama, jenis ");
  $query->execute();
  $i=0; $err="";
  $thn = substr $in{periode},0,4;
  $bln = substr $in{periode},5,2;
  $tglbayar = $bln."/01/".$thn;
  while (@rec = $query->fetchrow_array())
  {
     $flag=$dbk2->do("INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
     ('$in{periode}','$rec[0]','$rec[1]','$rec[2]','$rec[2]','$tglbayar','$s3s[0]');");
     if($flag!=0){ $i++; }
     else { $err.="'$rec[0]','$rec[1]','$rec[2]' <br/> "; }
  }
  print qq~<div class=warning_ok> Sukses Generate Iuran Periode '$in{periode}' = $i Record  </div>~;
  if($err ne ""){ print qq~<div class=warning_not_ok> $err  </div>~; }
 }
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

