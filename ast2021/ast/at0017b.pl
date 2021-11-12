sub at0017b {

genfuncast::validasi_akses($s3s[11], $in{ss});
&koneksi_ast2;

@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if($in{from})
{ $frompage=$in{from};
  if($in{rid}){  $addhidden=qq~<input name="rid" type="hidden" value=$in{rid}>~;  } #dari Terima Detail
  elsif($in{kd}){  $addhidden=qq~<input name="kd" type="hidden" value=$in{kd}>~; } #dari Detail Inventori
}
else {$frompage="at0017"; $addhidden=""; }

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>&nbsp;
     </td>
     <td align=center> <h2 class="hurufcol">Detail Serah Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
      </td> ~;
   print qq~
     </table>   $warning
~;

if($in{sid})
{ $query = $dba1->prepare("select nosurat, dtkirim,c.namacabang,jenis,nik,nlengkap,OPRCREATE, batal,c.kodecabang, flagpinjam
  from kirimh kh join getstruk c on kh.cabang_tuj=c.kodecabang
  left outer join getkry k on kh.idlama_tuj=k.idlama where recid=$in{sid}");
  $query->execute();
  @record = $query->fetchrow_array();
  $dto= genfuncast::mdytodmy($record[1]);
print qq~
  <table width='600px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;No. Surat </td>
    <td class="hurufcol" > $record[0]    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tgl Serah </td>
    <td class="hurufcol" > $dto    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Karyawan Tujuan </td>
    <td class="hurufcol" >  $record[4] - $record[5]   </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Cabang Tujuan </td>
    <td class="hurufcol" >$record[8] - $record[2]  </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Jenis </td>
    <td class="hurufcol" >  $record[3]  </td>
    </tr>
  <tr bgcolor=#dddddd height=20>
    <td class="hurufcol"> &nbsp;Peminjaman </td>
    <td class="hurufcol" >  <b>$record[9]</b>  </td>
    </tr>
  </table>   <br/> <br/>

  <table width='1100px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=60> Kode   </td>
   <td align='center' class="hurufcol" width=120> Nama Inv </td>
   <td align='center' class="hurufcol" width=40> Merek </td>
   <td align='center' class="hurufcol" width=40> Tipe </td>
   <td align='center' class="hurufcol" width=50> Ukuran </td>
   <td align='center' class="hurufcol" width=50> Warna </td>
   <td align='center' class="hurufcol" width=100> Pemilik Asal </td>
   <td align='center' class="hurufcol" width=80> Cabang Asal </td>
   <td align='center' class="hurufcol" width=80> Kondisi </td>
   <td align='center' class="hurufcol" width=100> Keterangan </td>
~;
  if ($record[9] eq 'Y')
  { print qq~ <td align='center' class="hurufcol" width=80> Sudah Kembali? </td>~;
  }
print qq~
  </tr>
~;
if($record[7] eq 'Y' ){ $bg='#ccc';  }
else { $bg=$colcolor; }

$query = $dba1->prepare("select namaklp, kode, namajenis, merek, tipe , ukuran, warna, kd.kondisi, kd.ket,
 kd.idlama_asal,curridlama,kd.kondisi_asal,kd.ket_asal,kd.cabang_asal, kembaliid from kirimd kd,
 inventori i, jenisinv j, klpjenisinv ki
 where  kd.kodeinv=i.kode and i.jenis=j.jenis and j.klpjenis=ki.klpjenis and kirimid=$in{sid} and batal='N' order by namaklp
");
  $query->execute();
  $no=1;
  $tmpnik="";  $tmpklp = "";
  while (@row = $query->fetchrow_array())
  {  $pemilik=""; $kondisi_asal=""; $ket_asal="";
     if($row[7] ne $row[11]){ $kondisi_asal="Dulu : <b>$row[11]</b>"; }
     if($row[8] ne $row[12]){ $ket_asal="Dulu : <b>$row[12]</b>"; }
     if($row[9] != $row[10] and $row[9]!=0)
     { $q = $dba2->prepare("select  nik, nlengkap from getkry where idlama='$row[9]'");
       $q->execute();
       @row2 = $q->fetchrow_array();
       $pemilik="$row2[0] - $row2[1]";
     }
     if($tmpklp ne $row[0])
     { print qq~ <tr bgcolor='$colcolor2' height=20>
     <td class="hurufcol"  colspan=12><b>$row[0]</b></td>
    </tr>~;
     }

     print qq~
    <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='center' class="hurufcol" valign='top'>
     <a class=huruflink href="asetbox.cgi?display=at0010b&kd=$row[1]&ss=$in{ss}&from=at0017b&sid=$in{sid}">$row[1]</a></td>
     <td align='left' class="hurufcol" valign='top'>$row[2]</td>
     <td align='center' class="hurufcol" valign='top'>$row[3]</td>
     <td align='center' class="hurufcol" valign='top'>$row[4]</td>
     <td align='center' class="hurufcol" valign='top'>$row[5]</td>
     <td align='center' class="hurufcol" valign='top'>$row[6]</td>
     <td align='left' class="hurufcol" valign='top'>$pemilik</td>
     <td align='center' class="hurufcol" valign='top'>$row[13]</td>
     <td align='center' class="hurufcol" valign='top'>$row[7]<br/> $kondisi_asal</td>
     <td align='left' class="hurufcol" valign='top'>$row[8]<br/> $ket_asal</td>~;
     if ($record[9] eq 'Y')
     { if($row[14])
       { $q = $dba2->prepare("select  nosurat from kirimh where recid='$row[14]'");
         $q->execute();
         @row2 = $q->fetchrow_array();
         print qq~ <td align='left' class="hurufcol" valign='top'>
         <a class=huruflink href="asetbox.cgi?display=at0013b&rid=$row[14]&ss=$in{ss}&from=at0017b&sid=$in{sid}">$row2[0]</a></td>~;
       }
       else { print qq~<td align='left' class="hurufcol" valign='top'>&nbsp;</td>~; }
     }

     print qq~ </tr>~;
     $tmpklp=$row[0];
    $no++;
  }

  $no--;
  print qq~ </table>
   ~;
}

print qq~
    <hr width="100" />
</center>~;
}


1

