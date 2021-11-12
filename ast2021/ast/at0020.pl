sub at0020 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Daftar Peminjaman');
genfuncast::validasi_akses($s3s[11], $in{ss});

@yesno = ("ALL", "Y","N");
if(!$in{batal}){ $in{batal}='N'; }
($month,$day,$year,$weekday) = &jdate(&today());
$month=substr "0$month",-2;
$pridtoday=$year."-".$month;

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
      <td align=right width=100>&nbsp; </td>
     <td align=center> <h2 class="hurufcol"> Daftar Peminjaman</h2> </td>
      <td align=right width=100>&nbsp; </td>
     </tr>
     </table>
~;

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"1150px",
      height:"95%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>
<script type="text/javascript">
function toKembali(n, i)
{  with(document.st)
   { cabang.value=n;
     currkry.value=i;
     submit();
   }
}
</script>
<FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='st'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0013k>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=cabang value=>
  <input type=hidden name=currkry value=>
  <input type=hidden name=from value=at0020>
  <table width='1100px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=80> Tgl Kirim  </td>
   <td align='center' class="hurufcol" width=80> Tgl Harus Kembali </td>
   <td align='center' class="hurufcol" width=80> Cabang Tujuan  </td>
   <td align='center' class="hurufcol" width=80> Karyawan Tujuan  </td>
   <td align='center' class="hurufcol" width=80> Kode Barang </td>
   <td align='center' class="hurufcol" width=80> No. Surat </td>
   <td align='center' class="hurufcol" width=150> Keterangan </td>
   <td align='center' class="hurufcol" width=80> Action</td>
  </tr>
~;

$q = $dba1->prepare("
select dtkirim, dthrskembali, cabang_tuj,  kodeinv, nosurat, h.ket||'-'||d.ket, h.recid, idlama_tuj from kirimh h, kirimd d
where h.recid=d.kirimid and flagpinjam='Y' and jenis='S' and h.batal='N'
 and kembaliid is null  order by dthrskembali
");
$q->execute();
$no=1;
while (@row = $q->fetchrow_array())
{ $dtkirim = genfuncast::mdytodmy($row[0]);
  $dtkembali = genfuncast::mdytodmy($row[1]);

  $kry="";
  if($row[7])
  {     $q2 = $dba2->prepare("select nik, nlengkap from getkry where idlama='$row[7]'");
        $q2->execute();
        @row2 = $q2->fetchrow_array();
        $kry = $row2[0]."-".$row2[1];
  }

  $btn="";
  if ($s3s[11] eq 'S' )
  { $btn = "
    <input type='submit' name='kembali$no' value='Kembalikan' class='huruf1' onClick=\"toKembali('$row[2]','$kry');\">&nbsp;";
  }

  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='center' class="hurufcol" valign='top'>$dtkirim</td>
     <td align='center' class="hurufcol" valign='top'>$dtkembali</td>
     <td align='center' class="hurufcol" valign='top'>$row[2]</td>
     <td align='center' class="hurufcol" valign='top'>$kry</td>
     <td align='center' class="hurufcol" valign='top'>
      <a class='iframe' href='/cgi-bin/asetbox.cgi?display=at0010b&kd=$row[3]&ss=$in{ss}'>$row[3]</a></td>
     <td align='center' class="hurufcol" valign='top'>
       <a class='iframe' href='/cgi-bin/asetbox.cgi?display=at0017b&sid=$row[6]&ss=$in{ss}'>$row[4]</a></td>
     <td class="hurufcol" valign='top'>$row[5]</td>
     <td align='center' valign='top'>$btn </td>
  </tr>
  ~;
  $no++;
}

print qq ~</table>
</form>~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

