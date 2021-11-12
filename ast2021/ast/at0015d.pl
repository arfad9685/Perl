sub at0015d {

genfuncast::view_header($in{ss}, $s3s[2], 'Approval Opname Cabang');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');
&koneksi_ast2;

@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if ($in{simpan})
{
# print("update opnameh set cabapp='Y',cabopr='$s3s[0]',dtcab='$in{dtcab}', oprupdate='$s3s[0]' where recid='$in{recido}';");
     $q1 = $dba1->do("update opnameh set cabapp='Y',cabopr='$s3s[0]',dtcab=current_timestamp, oprupdate='$s3s[0]' where recid='$in{recido}';");

    if($q1!=0){ $warning = "<div class=warning_ok>Sukses Approval </div>"; }

     else { $warning = "<div class=warning_not_ok>Gagal Approve Opname</div>"; }

}

print qq~
<!--<script type='text/javascript' src='/jquery.min.js'></script>-->
<script type='text/javascript' src='/jquery-ui.js'></script>
<link rel="stylesheet" href="/jquery-ui.css">


<div class="container">

<table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
<form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at0015>
      <input name="ss" type="hidden" value="$in{ss}">
</form>
     </td>
     <td align=center> <h2 class="hurufcol">APPROVAL</h2> </td>
     <td align=right width=200>
     </td>
     </tr>
     </table>   $warning
~;

if($in{recido})
{ $query = $dba1->prepare("select NOOPNAME, DTOPNAME, CABANG, namacabang, CABAPP, CABOPR, DTCAB, AUDAPP, AUDOPR, DTAUD, OPRCREATE
        from opnameh h, getstruk c where h.cabang=c.kodecabang and recid=$in{recido}");
  $query->execute();
  @record = $query->fetchrow_array();
  $dto= genfuncast::mdytodmy($record[1]);

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>



<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0015d>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=recido value="$in{recido}">


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
    <td class="hurufcol"> &nbsp;Approval Head Cabang </td>
    <td class="hurufcol" >  $record[4] ($record[5]) <br/> $record[6]   </td>
    </tr>
  </table>   <br/> <br/>

  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=60> Jenis Inventori  </td>
   <td align='left' class="hurufcol" width=60> Kode Inventori  </td>
   <td align='left' class="hurufcol" width=100> Nama Inventori </td>
   <td align='left' class="hurufcol" width=40> Merek </td>
   <td align='left' class="hurufcol" width=40> Tipe </td>
   <td align='left' class="hurufcol" width=50> Ukuran </td>
   <td align='left' class="hurufcol" width=50> Warna </td>
   <td align='left' class="hurufcol" width=100> Pemilik </td>
   <td align='left' class="hurufcol" width=80> Kondisi </td>
   <td align='left' class="hurufcol" width=100> Keterangan </td>
  </tr>

~;

  $query = $dba1->prepare("select  namaklp, kode, namajenis, merek, tipe , ukuran, warna, nik, nlengkap, d.kondisi, d.ket, idlama,
 oldidlama, oldkondisi, oldket
 from opnamed d, getkry k, inventori i, jenisinv j, klpjenisinv ki
 where  d.curridlama=k.idlama  and d.kodeinv=i.kode and i.jenis=j.jenis
 and j.klpjenis=ki.klpjenis  and opnameid=$in{recido}
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
print qq~
   </table> ~;
   
if($record[4] ne 'Y')
  { print qq~  <input type=submit name=simpan value=Approve class="huruf1" > ~;
  } else
  { print qq~   ~;
  }



print qq~
   </form>
   ~;
 }

print qq~
    <hr width="100" />
</center>~;
}


1

