sub kop020m {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Bayar Iuran Manual', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$bgsukarela2 = "#c9f7ad";
$bgsukarela = "#bfe8a7";
$bgsukareladark = "#a9e884";

if($s3s[0] eq 'XTIN'){ $xtin=0; }

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=right width=50><form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=kop020>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
      </td>
     <td align=center> <h2 class="hurufcol">BAYAR IURAN MANUAL</h2> </td>
      <td align=right width=50>&nbsp;
      </td>
     </tr>
     </table>
~;

($month,$day,$year,$weekday) = &jdate(&today());
$month=substr "0$month",-2;
$day=substr "0$day",-2;
$today = $month."/".$day."/".$year;
$dtbatas = $month."/05/".$year;
$periode = $year."-".$month;

if($in{simpan})
{  $sukses=0; $ctr=0;
   for ($i=1; $i<=$in{baris}; $i++)
   { if($in{"idlama$i"})
     {  $ctr++;
        if($xtin==1)
        { print "INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
          ('$in{periode}','".$in{"idlama$i"}."','P','".$in{"pokok$i"}."','".$in{"pokok$i"}."','".$in{"dtbayar$i"}."','$s3s[0]');<br/>
          INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
          ('$in{periode}','".$in{"idlama$i"}."','S','".$in{"sukarela$i"}."','".$in{"sukarela$i"}."','".$in{"dtbayar$i"}."','$s3s[0]');";
        }
        $flag1=$dbk2->do("INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
        ('$in{periode}','".$in{"idlama$i"}."','P','".$in{"pokok$i"}."','".$in{"pokok$i"}."','".$in{"dtbayar$i"}."','$s3s[0]');");
        $flag2=$dbk2->do("INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
        ('$in{periode}','".$in{"idlama$i"}."','S','".$in{"sukarela$i"}."','".$in{"sukarela$i"}."','".$in{"dtbayar$i"}."','$s3s[0]');");

        if($in{"angid$i"})
        {
           $subup="";
           if($in{"denda$i"})
           {
             $subup=", denda=".$in{"denda$i"};
             $in{"jmlbyra$i"}=$in{"jmlbyra$i"}+$in{"denda$i"};
           }
           
        if($xtin==1)
        { print "update angsuran set jmlbayar=".$in{"jmlbyra$i"}.", dtbayar='".$in{"dtbayar$i"}."', oprupdate='$s3s[0]' $subup
             where recid='".$in{"angid$i"}."';";
        }
           $q = $dbk->prepare("
           select p.recid, nik, nlengkap, count(a.recid) from pinjaman p
                join  getkry k on  p.idlama=k.idlama
                left outer join angsuran a on p.recid = a.pinjaman_id and p.batal='N'  and jmlbayar=0 and a.periode>'$in{periode}'
                 where  p.idlama = '".$in{"idlama$i"}."' and lunas='N'
                 group by  p.recid, nik, nlengkap");
           $q->execute();
           @row = $q->fetchrow_array();
           if($row[3]==0)
           { $flagp = $dbk2->do("update pinjaman set lunas='Y', oprupdate='$s3s[0]' where recid='$row[0]';");
             if ($flagp!=0){ print qq~<div class=warning_ok>Sukses Update Lunas=Y untuk Pinjaman $row[1]-$row[2]</div>~; }
             else { print qq~<div class=warning_not_ok>GAGAL Update Lunas=Y untuk Pinjaman $row[1]-$row[2]</div>~; }
           }

           $flag3=$dbk2->do("update angsuran set jmlbayar=".$in{"jmlbyra$i"}.", dtbayar='".$in{"dtbayar$i"}."', oprupdate='$s3s[0]' $subup
             where recid='".$in{"angid$i"}."';");
           if($flag1!=0 && $flag2!=0 && $flag3!=0){ $sukses++; }
           else { $err.="'$rec[0]','$rec[1]','$rec[2]' <br/> "; }
        }
        else
        {  if($flag1!=0 && $flag2!=0){ $sukses++; }
           else { $err.="'$rec[0]','$rec[1]','$rec[2]' <br/> "; }
        }
     }
   }
   
   if($sukses==$ctr){ print qq~<div class=warning_ok>Sukses Simpan Iuran $sukses orang </div>~; }
   else { print qq~<div class=warning_not_ok>Hanya Sukses Simpan Iuran $sukses dari $ctr orang <br/> $err  </div>~;  }
}

print qq~
<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop020m>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Periode </td>
    <td class="hurufcol" ><select name="periode" class="huruf1" id="periode">
                        ~;
($month,$day,$year,$weekday) = &jdate(&tambahhari(-90));
$month = substr "0".$month, -2;
$minprid=$year."-".$month;
($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0".$month, -2;
#$maxprid=$year."-".$month;
$maxprid = genfuncpyl::getPeriodeSC($month."/".$day."/".$year);
$query = $dbk->prepare("select distinct recid from periode where recid >= '$minprid' and recid <= '$maxprid' order by recid desc rows 1 to 3 ");
$query = $dbk->prepare("select distinct recid from periode order by recid desc rows 1 to 3 ");
print "select distinct recid from periode where recid >= '$minprid' and recid <= '$maxprid' order by recid desc rows 1 to 3 ";
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{periode} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] </option>~;
}
print qq~
    </select>
    </td>
    <td class="hurufcol" width=100> &nbsp; Cabang </td>
    <td class="hurufcol" ><select name="cabang" class="huruf1" id="cabang">
    <option value=''>ALL</option> ~;
$query = $dbk->prepare("select distinct kodecabang, namastore from anggota a, getkry k where a.idlama = k.idlama order by kodecabang ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{cabang} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] - $rec[1] </option>~;
}
print qq~
    </select>
    </td>
    <td><input type='submit' name='viewi' value='View Iuran'> </td>
  </tr>
</table>
</form>    ~;

if($in{viewi})
{
  $tahun = substr $in{periode},0,4;
  $bulan = substr $in{periode},5,2;
  $bulan=$bulan-0;
  if (($in{periode}eq'2020-05')||($in{periode}eq'2020-06')){
        print 'Tidak usa dibayar';
        exit;
  }
  print qq~
<script type='text/javascript'>
function hitungDenda(dt, pinj, no)
{
  var today = new Date();
  var dd = today.getDate();
  var mm = today.getMonth()+1; //January is 0!
  var yyyy = today.getFullYear();

  var date1 = new Date($bulan+'/05/'+$tahun);
  var date2 = new Date(dt);
  var dd2 = date2.getDate();
  var mm2 = date2.getMonth()+1;
  var timeDiff = Math.abs(date2.getTime() - date1.getTime());
  var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

  if((mm2==$bulan && dd2>5) || mm2>$bulan)
  {
   var d = diffDays * 0.1 * pinj / 100;
   d = Math.round(d);
  }
  else
  { d=0;
  }
  document.getElementById('denda'+no).value = d;
}
</script>

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop020m>
  <input type=hidden name=periode value="$in{periode}">
<table>
  <tr bgcolor=$dark height=20>
    <td class="hurufcol" align=center width=30> No </td>
    <td class="hurufcol" align=center width=150> Cabang </td>
    <td class="hurufcol" align=center width=200> Karyawan </td>
    <td class="hurufcol" align=center width=80> Iuran Pokok</td>
    <td class="hurufcol" align=center width=80> Iuran Sukarela</td>
    <td class="hurufcol" align=center width=80> Angsuran Bulan Ini</td>
    <td class="hurufcol" align=center width=80> Bunga</td>
    <td class="hurufcol" align=center width=100> Total</td>
    <td class="hurufcol" align=center width=80> Tgl Bayar</td>
    <td class="hurufcol" align=center width=80> Denda</td>
    <td class="hurufcol" align=center width=80> Sudah Bayar?</td>
  </tr>
  ~;
  
$subq="";
if($in{cabang}){ $subq=" and k.kodecabang='$in{cabang}' "; }

@arr = split(/\-/,$in{periode});
$dtmaxjoin = $arr[1]."/28/".$arr[0];

if($s3s[0] eq 'LEONARD')
{
print qq~select a.idlama, kodecabang, namastore, nik, nlengkap, jenis, jumlah, hrsbayar, bunga, x.recid, jmlpengajuan
from anggota a join simpanan s on a.idlama=s.idlama
join  getkry k on a.idlama=k.idlama
left outer join
(select a.recid, idlama, hrsbayar, bunga, jmlpengajuan from angsuran a, pinjaman p
where p.recid=a.pinjaman_id and a.periode='$in{periode}'  and a.batal='N') x on a.idlama=x.idlama
        where   dtexpired='1/1/2099' and a.aktif='Y'   $subq
        and a.idlama not in (select distinct idlama from iuran where periode='$in{periode}' )
        and a.dtjoin<='$dtmaxjoin'
        order by kodecabang, a.idlama, jenis <br/> ~;
}

  $query = $dbk->prepare("
select a.idlama, kodecabang, namastore, nik, nlengkap, jenis, jumlah, hrsbayar, bunga, x.recid, jmlpengajuan
from anggota a join simpanan s on a.idlama=s.idlama
join  getkry k on a.idlama=k.idlama
left outer join
(select a.recid, idlama, hrsbayar, bunga, jmlpengajuan from angsuran a, pinjaman p
where p.recid=a.pinjaman_id and a.periode='$in{periode}'  and a.batal='N') x on a.idlama=x.idlama
        where   dtexpired='1/1/2099' and a.aktif='Y'   $subq
        and a.idlama not in (select distinct idlama from iuran where periode='$in{periode}' )
        and a.dtjoin<='$dtmaxjoin'
        order by kodecabang, a.idlama, jenis ");
  $query->execute();
  $no=1;
  while (@rec = $query->fetchrow_array())
  { if($rec[5] eq 'P')
    { $pokok=$rec[6];
      $txtpokok=genfuncpyl::ribuan($rec[6]);

      if($no%2==0){ $bg = $colcolor; }
      else { $bg=$colcolor2; }
      print qq~
      <tr bgcolor=$bg height=20  class="hurufcol">
      <td align=center> $no </td>
      <td> $rec[1]-$rec[2] </td>
      <td> $rec[3]-$rec[4] </td>
      <td align=right> $txtpokok </td>
      ~;

    }
    else
    { $sukarela=$rec[6];
      $txtsukarela=genfuncpyl::ribuan($rec[6]);

      $angsuran=0; $bunga=0; $subchange=""; $inputdenda="";
      if($rec[7])
      { $angsuran=$rec[7];
        $bunga = $rec[8];
        $jmlbyrangsuran = $angsuran+$bunga;
        $subchange = qq~onChange="hitungDenda(this.value,$rec[10],$no)"~;
        $inputdenda = qq~<input type=text id="denda$no" name="denda$no" value=0 readonly size=8 style='text-align:right'>~;
      }
      $txtangsuran=genfuncpyl::ribuan($angsuran);
      $txtbunga=genfuncpyl::ribuan($bunga);
      
      $total=$pokok+$sukarela+$angsuran+$bunga;
      $txttotal=genfuncpyl::ribuan($total);           #hitungDenda(this.value,$rec[10],$no)
      print qq~
      <td align=right> $txtsukarela </td>
      <td align=right> $txtangsuran </td>
      <td align=right> $txtbunga </td>
      <td align=right> $txttotal </td>
      <td align=right> <input class='huruf1' name="dtbayar$no" type="text" id="dtbayar$no" size="12" maxlength="12" value="" $subchange/>
       <img src="/jscalendar/img.gif" id="trigger$no" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtbayar$no",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger$no"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script></td>
      <td align=right> $inputdenda </td>
      <td align=center>
      <input type='hidden' name='pokok$no' value='$pokok'>
      <input type='hidden' name='sukarela$no' value='$sukarela'>
      <input type='hidden' name='angid$no' value='$rec[9]'>
      <input type='hidden' name='jmlbyra$no' value='$jmlbyrangsuran'>
      <input type='checkbox' name='idlama$no' value='$rec[0]'></td>
      </tr> ~;
      $no++;
    }
  }
  $no--;
  print qq~</table>~;
  if($no>=1){ print qq~<input type=hidden name=baris value=$no> <input type=submit name=simpan value='Simpan $no'> ~; }
  print qq~</form>~;
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

