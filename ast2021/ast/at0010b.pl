sub at0010b {

genfuncast::validasi_akses($s3s[11], $in{ss});

&koneksi_ast2;

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>&nbsp;
     </td>
     <td align=center> <h2 class="hurufcol">Detail Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;


#print("select i.kode,j.namajenis,m.namamerek,w.namawarna,t.namatipe,u.namaukuran,case when i.flagasset='N' then 'No' else  'Yes' end Flagasset,case when i.kondisi='L' then 'Layak' else 'Rusak' end Kondisi,i.noseri,i.ip,s.namacabang,k.nlengkap,k.nik,i.oprcreate,i.kodelama,i.os,i.computername,i.keterangan,i.dtbeli,i.harga
#from inventori i
#left outer join jenisinv j on i.jenis=j.jenis
#left outer join merek m on i.merek=m.merek
#left outer join tipeinv t on i.tipe=t.tipe
#left outer join ukuraninv u on i.ukuran=u.ukuran
#left outer join warna w on i.warna=w.warna
#left outer join getstruk s on s.kodecabang=i.currcabang
#left outer join getkry k on k.idlama=i.curridlama
#where i.kode='$in{kd}' order by j.jenis, i.dtcreate desc ");

if($in{kd})
{


$query = $dba1->prepare("select i.kode,j.namajenis,m.namamerek,w.namawarna,t.tipe,u.namaukuran,case when i.flagasset='N' then 'No' else  'Yes' end Flagasset,
case when i.kondisi='L' then 'Layak' when i.kondisi='B' then 'Baru' else 'Rusak' end Kondisi,i.noseri,i.ip,s.namacabang,
k.nlengkap, k.nik, i.oprcreate, i.kodelama, i.os, i.computername, i.keterangan, i.dtbeli, i.harga, i.kodeasset,
i.groupkode
from inventori i
left outer join jenisinv j on i.jenis=j.jenis
left outer join merek m on i.merek=m.merek
left outer join tipeinv t on i.tipe=t.tipe
left outer join ukuraninv u on i.ukuran=u.ukuran
left outer join warna w on i.warna=w.warna
left outer join getstruk s on s.kodecabang=i.currcabang
left outer join getkry k on k.idlama=i.curridlama
where i.kode='$in{kd}' order by j.jenis, i.dtcreate desc ");
$query->execute();
@record = $query->fetchrow_array();

$ketgrup="";
if($record[21]){ $ketgrup=" (Group : $record[21])"; }

$kda="";
if($record[6] eq 'Yes'){ $kda = "&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Kode Asset : $record[20] "; }
print qq~
$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0010e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>
  <table width='680px' border='0' cellspacing='1' cellpadding='2'>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol">&nbsp;Kode Inventori </td>
    <td class="hurufcol" bgcolor=$colcolor2 > $in{kd}  &nbsp;&nbsp; &nbsp;&nbsp; $ketgrup
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Jenis Inventori </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[1]

&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; Flag Asset :
 $record[6]  $kda
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Merek </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[2]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Model / Tipe </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[4]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Ukuran </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[5]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Warna </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[3]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Nomor Seri </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[8]
    &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Kode Lama
    : $record[14]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Kondisi </td>
<td class="hurufcol" bgcolor=$colcolor2>$record[7]</td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Keterangan </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[17]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
   <td class="hurufcol">&nbsp;Tanggal Beli</td>
   <td class="hurufcol" bgcolor=$colcolor2> $record[18]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Harga </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[19]    </td>
  </tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol">&nbsp;Nama Karyawan </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[12] - $record[11]
     &nbsp; &nbsp;/ Cabang Store : $record[10]
     </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Computer Name</td>
    <td class="hurufcol" bgcolor=$colcolor2>$record[16]
     &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; IP :
    $record[9]
    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; OS :
   $record[15]
    </td>
</tr>

</table>

<td align=center> <h2 class="hurufcol">Serah Terima</h2> </td>

 <table width='1100px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=100> Tanggal Kirim   </td>
   <td align='left' class="hurufcol" width=100> No Surat </td>
   <td align='left' class="hurufcol" width=100> Serah ke </td>
   <td align='left' class="hurufcol" width=100> Terima Dari </td>
   <td align='left' class="hurufcol" width=100> Cabang Tujuan </td>
   <td align='left' class="hurufcol" width=100> Cabang Asal </td>
   <td align='left' class="hurufcol" width=80> Kondisi </td>
   <td align='left' class="hurufcol" width=100> Keterangan </td>
  </tr>
~;

#print("select kh.dtkirim,kh.nosurat,kh.idlama_tuj,kh.cabang_tuj,kd.idlama_asal,kd.cabang_asal,kd.kondisi_asal
# ,kd.ket_asal,kd.kondisi,kd.ket,ks1.namacabang,ks2.namacabang
# from kirimh kh
# join kirimd kd on kh.recid=kd.kirimid
# join getstruk ks1 on ks1.kodecabang=kh.cabang_tuj
# join getstruk ks2 on ks2.kodecabang=kd.cabang_asal
# where kd.kodeinv='$in{kd}' order by kh.dtkirim
#");

$query = $dba1->prepare("select kh.dtkirim,kh.nosurat,kh.idlama_tuj,kh.cabang_tuj,kd.idlama_asal,kd.cabang_asal,kd.kondisi_asal
 ,kd.ket_asal,kd.kondisi,kd.ket,ks1.namacabang,ks2.namacabang,kh.recid,kh.jenis
 from kirimh kh
 join kirimd kd on kh.recid=kd.kirimid
 join getstruk ks1 on ks1.kodecabang=kh.cabang_tuj
 join getstruk ks2 on ks2.kodecabang=kd.cabang_asal
 where kd.kodeinv='$in{kd}' and kd.batal='N' order by kh.dtkirim
");
  $query->execute();
  $no=1;
  while (@row = $query->fetchrow_array())
  {  $pemilik=""; $kondisi_asal=""; $ket_asal="";$pemilik2="";
     if($row[6] ne $row[8]){ $kondisi_asal="Dulu : <b>$row[6]</b>"; }
     if($row[7] ne $row[9]){ $ket_asal="Dulu : <b>$row[7]</b>"; }
     if($row[2] != $row[4])
     { $q = $dba2->prepare("select  nik, nlengkap from getkry where idlama='$row[2]'");
       $q->execute();
       @row2 = $q->fetchrow_array();
        $pemilik="$row2[1]";
     }
     if($row[4] != 0)
     { $q = $dba2->prepare("select  nik, nlengkap from getkry where idlama='$row[4]'");
       $q->execute();
       @row3 = $q->fetchrow_array();
        $pemilik2="$row3[1]";
     }

   $dto= genfuncast::mdytodmy($row[0]);
   


     print qq~
    <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='left' class="hurufcol" valign='top'>$dto</td>
     <td align='left' class="hurufcol" valign='top'>~;
  if ($row[13] eq 'S'){
    print qq~<a class=huruflink href="asetbox.cgi?display=at0017b&sid=$row[12]&ss=$in{ss}&from=at0010b&kd=$in{kd}">$row[1]</a> ~;}
  if ($row[13] eq 'T'){
    print qq~<a class=huruflink href="asetbox.cgi?display=at0013b&rid=$row[12]&ss=$in{ss}&from=at0010b&kd=$in{kd}">$row[1]</a> ~;}
  print qq~
    </td>
     <td align='left' class="hurufcol" valign='top'>$pemilik</td>
     <td align='left' class="hurufcol" valign='top'>$pemilik2</td>
     <td align='left' class="hurufcol" valign='top'>$row[10]</td>
     <td align='left' class="hurufcol" valign='top'>$row[11]</td>
      <td align='left' class="hurufcol" valign='top'>$row[8]<br/> $kondisi_asal</td>
     <td align='left' class="hurufcol" valign='top'>$row[9]<br/> $ket_asal</td>
    </tr>
    
     ~;
    $no++;

  }


  print qq~ </table> ~;


  print qq~
  <td align=center> <h2 class="hurufcol">Detail Opname</h2> </td>
 <table width='1100px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=110> Tanggal Opname   </td>
   <td align='left' class="hurufcol" width=100> No Opname </td>
   <td align='left' class="hurufcol" width=100> Cabang </td>
   <td align='left' class="hurufcol" width=100> Kondisi </td>
   <td align='left' class="hurufcol" width=100> Keterangan </td>
   <td align='left' class="hurufcol" width=100> Created By </td>
   <td align='left' class="hurufcol" width=110> Approval Head Cabang </td>
   <td align='left' class="hurufcol" width=100> Approval Head Audit </td>
  </tr>
  ~;
  
#print("select oh.dtopname,oh.noopname,oh.cabang,os.namacabang,oh.oprcreate,oh.cabapp,oh.cabopr,oh.dtcab,oh.audapp,oh.audopr,oh.dtaud,od.kondisi,od.ket,od.oldkondisi,od.oldket
#from opnameh oh
#join opnamed od on od.opnameid=oh.recid
#join getstruk os on os.kodecabang=oh.cabang
#where od.kodeinv='$in{kd}' order by oh.dtopname");
  
$q = $dba1->prepare("select oh.dtopname,oh.noopname,oh.cabang,os.namacabang,oh.oprcreate,oh.cabapp,oh.cabopr,oh.dtcab,oh.audapp,oh.audopr,oh.dtaud,od.kondisi,od.ket,od.oldkondisi,od.oldket,oh.recid
from opnameh oh
join opnamed od on od.opnameid=oh.recid
join getstruk os on os.kodecabang=oh.cabang
where od.kodeinv='$in{kd}'  order by oh.dtopname");
$q->execute();
$no=1;
while (@row = $q->fetchrow_array())
{
  $dt = genfuncast::mdytodmy($row[0]);

  print qq~
  <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='left' class="hurufcol" valign='top'>$dt</td>
     <td align='left' class="hurufcol" valign='top'>
     <a class=huruflink href="sisasset.cgi?pages=at0014d&rid=$row[15]&ss=$in{ss}&from=at0010b&kd=$in{kd}">$row[1]</a></td>
     <td align='left' class="hurufcol" valign='top'>$row[3]</td>
     <td align='left' class="hurufcol" valign='top'>$row[11]<br/> Dulu :$row[13] </td>
     <td align='left' class="hurufcol" valign='top'>$row[12]<br/> Dulu :$row[14]</td>
     <td align='left' class="hurufcol" valign='top'>$row[4]</td>
     <td align='left' class="hurufcol" valign='top'>$row[5] ($row[6]) <br/> $row[7] </td>
     <td align='left' class="hurufcol" valign='top'>$row[8] ($row[9]) <br/> $row[10]</td>

  </tr>
  ~;
  $no++;
}
  $no--;
  print qq~ </table> ~;
 }
print qq~
</form>
    <hr width="100" />
</center>~;

 }

1

