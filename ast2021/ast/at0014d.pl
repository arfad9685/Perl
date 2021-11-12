sub at0014d {

genfuncast::view_header($in{ss}, $s3s[2], 'Detail Opname');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');
&koneksi_ast2;

@kondisi = ('B','L','W');
@kondisitext = ('Baru','Layak','Waste');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if($in{from})
{ $frompage=$in{from};
  if($in{kd}){  $addhidden=qq~<input name="kd" type="hidden" value=$in{kd}>~; } #dari Detail Inventori
}
else {$frompage="at0014"; $addhidden=""; }

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=$frompage>  $addhidden
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Detail Opname</h2> </td>
     ~;

if($in{rid})
{ $query = $dba1->prepare("select NOOPNAME, DTOPNAME, CABANG, namacabang, CABAPP, CABOPR, DTCAB, AUDAPP, AUDOPR, DTAUD, OPRCREATE
        from opnameh h, getstruk c where h.cabang=c.kodecabang and recid=$in{rid}");
  $query->execute();
  @record = $query->fetchrow_array();
  $dto= genfuncast::mdytodmy($record[1]);
  
 if($record[4] ne 'Y')
  { print qq~
        <td align=right width=200>
        <form method=post action="/cgi-bin/sisasset.cgi" >
        <input type=submit name=back value=EDIT class="huruf1" >
        <input name="pages" type="hidden" value=at0014e>
        <input name="ss" type="hidden" value="$in{ss}">
        <input name="recido" type="hidden" value=$in{rid}>
        </form>
        </td>
        ~;
  } else
  { print qq~  <td align=right width=200>
     &nbsp;
     </td>  ~;
  }
  print qq~ </tr>
   </table>   $warning
~;


print qq~
  <table width='450px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;No. Opname </td>
    <td class="hurufcol" > $record[0]    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tanggal Opname </td>
    <td class="hurufcol" > $dto    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Cabang </td>
    <td class="hurufcol" >  $record[2]-$record[3]   </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Auditor </td>
    <td class="hurufcol" >  $record[10]   </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Approval Head Cabang </td>
    <td class="hurufcol" >  $record[4] ($record[5]) <br/> $record[6]   </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Approval Head Audit </td>
    <td class="hurufcol" >   $record[7] ($record[8]) <br/> $record[9]   </td>
    </tr>
</table>   <br/> <br/>

  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=100> Jenis Inventori  </td>
   <td align='left' class="hurufcol" width=100> Kode Lama </td>
   <td align='left' class="hurufcol" width=100> Kode Inventori   </td>
   <td align='left' class="hurufcol" width=100> Nama Inventori </td>
   <td align='left' class="hurufcol" width=40> Merek </td>
   <td align='left' class="hurufcol" width=40> Tipe </td>
   <td align='left' class="hurufcol" width=50> Ukuran </td>
   <td align='left' class="hurufcol" width=50> Warna </td>
   <td align='left' class="hurufcol" width=100> Pemilik </td>
   <td align='left' class="hurufcol" width=60> Kondisi </td>
   <td align='left' class="hurufcol" width=100> Keterangan </td>
  </tr>
~;

  $query = $dba1->prepare("select  namaklp, kode, namajenis, merek, tipe , ukuran, warna, nik, nlengkap, d.kondisi, d.ket, idlama,
 oldidlama, oldkondisi, oldket,kodelama
 from opnamed d, getkry k, inventori i, jenisinv j, klpjenisinv ki
 where  d.curridlama=k.idlama  and d.kodeinv=i.kode and i.jenis=j.jenis
 and j.klpjenis=ki.klpjenis  and opnameid=$in{rid}
 order by nik, namaklp");
  $query->execute();
  $no=1;
  $tmpnik="";
  while (@row = $query->fetchrow_array())
  {  $oldpemilik=""; $oldkondisi=""; $oldket="";
     if($row[9] ne $row[13]){ $oldkondisi="Dulu : <b>$row[13]</b>"; }
     if($row[10] ne $row[14]){ $oldket="Dulu : <b>$row[14]</b>"; }
     if($row[11] != $row[12])
     { $q = $dba2->prepare("select  nik, nlengkap from getkry where idlama='$row[12]'");
       $q->execute();
       @row2 = $q->fetchrow_array();
        $oldpemilik="Dulu : <b>$row2[0] - $row2[1]</b>";
     }
     print qq~
    <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='left' class="hurufcol" valign='top'>$row[0]</td>
     <td align='left' class="hurufcol" valign='top'>$row[15]</td>
     <td align='left' class="hurufcol" valign='top'><a class=huruflink href="sisasset.cgi?pages=at0010d&kd=$row[1]&ss=$in{ss}">$row[1]</a></td>
     <td align='left' class="hurufcol" valign='top'>$row[2]</td>
     <td align='left' class="hurufcol" valign='top'>$row[3]</td>
     <td align='left' class="hurufcol" valign='top'>$row[4]</td>
     <td align='left' class="hurufcol" valign='top'>$row[5]</td>
     <td align='left' class="hurufcol" valign='top'>$row[6]</td>
     <td align='left' class="hurufcol" valign='top'>$row[7]-$row[8]<br/>$oldpemilik</td>
     <td align='left' class="hurufcol" valign='top'>$row[9]<br/>$oldkondisi</td>
     <td align='left' class="hurufcol" valign='top'>$row[10]<br/>$oldket</td>
    </tr>
     ~;
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

