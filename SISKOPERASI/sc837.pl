sub sc837 {
#use Date::Calc qw(Add_Delta_Days);
#use Date::Calc qw(Day_of_Week);

&koneksi_pyl3;


genfuncpyl::view_header($in{ss},$s3s[2], 'Expired Seragam');
genfuncpyl::validasi_akses($s3s[11], $in{ss}, 'S');

$qrsize = $dbp->prepare("SELECT tipesgid, ket from cmdtipesg ");
$qrsize->execute();
$a=0;
while(@rsize = $qrsize->fetchrow_array()){
$uku[$a]=$rsize[0];
@tipesize=split(',', $rsize[1]);
$jmlhuk[$a]=  @tipesize;

for ($i=0;$i<@tipesize;$i++){
$uku[$a][$i]=$tipesize[$i];
}

$a++;

}


($month,$day,$year,$weekday) = &jdate(&today());

$hari1 = $weekday;
if (length($month)<2) {
  $thnbln='0'.$month;
} else {
  $thnbln=$month;
}

$month = substr "0$month",-2;
$day = substr "0$day",-2;
$today = $month.'/'.$day.'/'.$year;

$t='0'.$month;

if ($in{save}){
          $no2=1;
          $tesno=1;

          $periodsc = genfuncpyl::getPeriodeSC($in{periode1});
        until ($no2 > $in{nomor}) {
                $recid=$in{"recid$no2"};
                $size=$in{"size$no2"};
                $ket=$in{"ket$no2"};
                $nik2=$in{"cek$no2"};
                $nik=$in{"nik$no2"};
                $nmtg=$in{"nmtg$no2"};
                $kodesg=$in{"kodesg$no2"};
                $serid=$in{"serid$no2"};
                $kode=substr $kodesg ,0, 3 ;
#                print $kode,$nmtg.$periodsc.'<br>';
                if ($nmtg){
#                                        print "update sgserimad set  namapanggil='$nmtg' where recid='$recid'";
                                        $dbp->do("update sgserimad set  namapanggil='$nmtg' where serimaid='$serid' and kodesg='$kodesg' ");
                }

                if ($nik2){
                        $q = $dbp->prepare("SELECT saldoakhir from sgstok where kodesg='$kodesg' and ukuran='$size'");
                        $q->execute();
                        @row = $q->fetchrow_array();
                        if($row[0]<1){
                                print $kodesg."<div class=warning_not_ok>$kodesg $size tidak cukup stok </div><br>";
                        } else {

                        if ($kode eq 'NTG'){
                                if ($nmtg){
#                                        print "update sgserimad set ukuran='$size', dtserah='$in{periode1}', usrserah='$in{usrserah}', ketserah='$ket',
#                                        periodserah='$periodsc' where recid='$recid'";
                                        $dbp->do("update sgserimad set ukuran='$size', dtserah='$in{periode1}', usrserah='$in{usrserah}', ketserah='$ket',
                                        periodserah='$periodsc', namapanggil='$nmtg' where recid='$recid'");
                                }
#                                else {
#                                        print 'Namatag '.$nik.' harus diiisi<br>';
#                                }
                        } else {
#                                print "update sgserimad set ukuran='$size', dtserah='$in{periode1}', usrserah='$in{usrserah}', ketserah='$ket',
#                        periodserah='$periodsc' where recid='$recid'";
                        $dbp->do("update sgserimad set ukuran='$size', dtserah='$in{periode1}', usrserah='$in{usrserah}', ketserah='$ket',
                        periodserah='$periodsc', namapanggil='$nmtg' where recid='$recid'");
                        }
                        }

#                        print 'aa';

                }
                $no2++;
        }
#        $dbp->do("update sgruled  set jumlah='$in{jumlah}' where  ruleid='$in{koderule}' and kodesg='$in{kodesg}'");


        #$dbp->commit;
        print 'Proses bagi seragam selesai';
 }


#print $hari1;
print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>
<script type='text/javascript' src='/jquery-ui.js'></script>
<link rel="stylesheet" href="/jquery-ui.css">
<style>
  .ui-autocomplete-category {
    font-weight: bold;
    padding: .2em .4em;
    margin: .8em 0 .2em;
    line-height: 1.5;
  }
  </style>
  <script>
  \$.widget( "custom.catcomplete", \$.ui.autocomplete, {
    _create: function() {
      this._super();
      this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
    },
    _renderMenu: function( ul, items ) {
      var that = this,
        currentCategory = "";
      \$.each( items, function( index, item ) {
        var li;
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        li = that._renderItemData( ul, item );
        if ( item.category ) {
          li.attr( "aria-label", item.category + " : " + item.label );
        }
      });
    }
  });
  </script>
  <script>
  \$(function() {
    var data = [
~;
$query = $dbp->prepare("
select nik, nlengkap, kodecabang  from $tblstaf  where aktif = 'Y' ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0] - $rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$( "#nikgo" ).catcomplete({
      delay: 0,
      source: data
    });
  });
  </script>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align='right' width=50>
      <form method=post action="/cgi-bin/sispayroll.cgi" >

      <input name="pages" type="hidden" value=sc825>
      <input name="ss" type="hidden" value="$in{ss}">
      <input type=hidden name=kodestore value="$in{kodestore}">
          <input type=hidden name=status value="$in{status}">
          <input type=hidden name=posisi value="$in{posisi}">
          <input type=hidden name=search value="aa"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">EXPIRED SERAGAM</h2> </td>
          <td align='center' width=100>
          &nbsp;
          </td>
     </tr>
     </table>

  <form method=post action="/cgi-bin/sispayroll.cgi" name="prfr" id="prfrid"  >
  <table width=500 border="0" cellspacing="1" cellpadding="1" align='center'>
   <tr bgcolor=$colcolor height=20>
   <td class="hurufcol" width=70> &nbsp;Periode </td>
    <td class="hurufcol" ><select name="period" id="period" class="huruf1">
                        ~;
                        if (! defined $sth_period) {
                                $sth_period = $dbp->prepare("SELECT recid FROM periodsc ORDER BY recid desc");
                        }
                        $sth_period->execute();
                        while( @period = $sth_period->fetchrow_array())
                        {       $selected="";
                                if ($period[0] eq $in{period}) { $selected="selected"; }
                                print qq~<option value="$period[0]" $selected>$period[0]</option>~;
                        }
                        print qq~
         </select>
    </td>
   </tr>
   <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=70> &nbsp;Rule </td>
    <td class="hurufcol" colspan='3' ><select name="ruleid" id="ruleid" class="huruf1">
    ~;
                                $str = "SELECT ruleid from sgruleh order by ruleid";
                                $sth_store = $dbp->prepare($str);
                        $sth_store->execute();
                        while( @store = $sth_store->fetchrow_array())
                        {       $selected="";
                                if ($in{ruleid} eq $store[0]) { $selected="selected"; }
                                 print qq~<option value="$store[0]" $selected>$store[0]</option>~;
                        }
                        print qq~
         </select>
    </td>
   </tr>
   <tr bgcolor=$colcolor height=20>
    <td width=120 class="hurufcol">&nbsp;Karyawan </td>
<td  align=left colspan=3> <input type=text name=nikgo id=nikgo value='$in{nikgo}' class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
   </tr>

    <tr bgcolor=$colcolor height=20 >
           <td colspan=15 align=center><input type="submit" name="view" value="Go" class="huruf1"/>
           <input type=hidden name=ss value="$in{ss}">
           <input type=hidden name=nomor value="$no">
          <input type=hidden name=pages value=sc837></td>
          </tr>
  </table>
        </form>
        <br>
~; if ($in{view}) {
$nik= substr $in{nikgo},0,9;
$nik=$nik.'%';
($dt1,$dt2) = genfuncpyl::GetPeriodDt($in{period});
#($dt1,$dt2) = genfuncpyl::GetPeriodDt('2016-10');

print qq~
  <form method=post action="/cgi-bin/sispayroll.cgi" name="prfr" id="prfrid"  >

  <table width='1000px' border='0' cellspacing='1' cellpadding='2'>

  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=5%> No.</td>
   <td align='center' class="hurufcol" width=7%> NIK</td>
   <td align='center' class="hurufcol" width=20%> Nama</td>
   <td align='center' class="hurufcol" width=20%> Cabang</td>
   <td align='center' class="hurufcol" width=5%> Status</td>
   <td align='center' class="hurufcol" width=7%> Rule </td>
   <td align='center' class="hurufcol" width=20%> Seragam </td>
   <td align='center' class="hurufcol" width=7%> Deposit </td>
   <td align='center' class="hurufcol" width=5%> Size </td>
   <td align='center' class="hurufcol" width=5%> Tgl Serah </td>
   <td align='center' class="hurufcol" width=10%> Keterangan </td>
   <td align='center' class="hurufcol" width=7%> Nm Tag </td>
   <td align='center' class="hurufcol" width=7%> Action </td>
   </tr>
 ~;

$q = $dbp->prepare("SELECT a.nik, a.ruleid, a.statuskerja, b.kodesg, b.jumlah, b.depserah, b.dtserah, s.nlengkap, c.namasg, b.recid, c.asize, b.namapanggil, d.namastore, b.serimaid
from sgserimah a, sgserimad b, $tblstaf s, cmdseragam c, cabang d where a.nik=s.nik and a.recid=b.serimaid and b.kodesg=c.kodesg
 and (datediff(month, b.dtserah,date '$dt1')=c.masa-1 or datediff(month, b.dtserah,date '$dt2')=c.masa-1)  and a.ruleid='$in{ruleid}' and
a.cabang=d.kode and b.dtterima is null and a.nik like '$nik'");
#print "SELECT a.nik, a.ruleid, a.statuskerja, b.kodesg, b.jumlah, b.depserah, b.dtserah, s.nlengkap, c.namasg, b.recid, c.asize, b.namapanggil, d.namastore, b.serimaid
#from sgserimah a, sgserimad b, $tblstaf s, cmdseragam c, cabang d where a.nik=s.nik and a.recid=b.serimaid and b.kodesg=c.kodesg
# and datediff(month, b.dtserah,date '$dt1')=c.masa-1 and a.ruleid='$in{ruleid}' and
#a.cabang=d.kode and b.dtterima is null";
$q->execute();

$no=1;
$tmpcab = '';
while (@row = $q->fetchrow_array())
  {
  $dtplan = genfuncpyl::mdytodmy($row[6]);
  print qq~

    <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     ~; if ($row[0] eq $name){ print qq~
     <td align='center' class="hurufcol" valign="top" colspan=4></td>
     ~; } else { print qq~
     <td align='center' class="hurufcol" valign="top">$row[0]</td>
     <td align='left' class="hurufcol" valign="top">$row[7]</td>
     <td align='left' class="hurufcol" valign="top">$row[12]</td>
     <td align='center' class="hurufcol" valign="top">$row[2]</td>
     ~; } print qq~
     <td align='left' class="hurufcol" valign="top">$row[1]</td>
     <td align='left' class="hurufcol" valign="top">$row[3]  $row[8]</td>
     <td align='right' class="hurufcol" valign="top">$row[5]</td>

     <td align='left' class="hurufcol" valign="top" ><select name=size$no onChange="document.getElementById('cek$no').checked=true;" >
     ~; for ($a=0; $a<6; $a++){
                if($uku[$a] eq $row[10]){
                        for ($i=0;$i<$jmlhuk[$a];$i++){ print qq~
                                <option value='$uku[$a][$i]'>$uku[$a][$i]</option>
                         ~; }
                }
     } print qq~
     </select></td>
     <td align='left' class="hurufcol" valign="top">$dtplan</td>
     <td align='left' class="hurufcol" valign="top"><input type=text name=ket$no  maxlength=50 size=10></td>
     ~;  $nametag=substr $row[3],0,3;
     if ($nametag eq 'NTG') {
        if ($row[11]) { print qq~
                <td align='left' class="hurufcol" valign="top">$row[11]</td>
                <td align='center' class="hurufcol" valign="top"><input type='checkbox'  name='cek$no' id='cek$no' value="$row[0]">
                <input type=hidden name=nik$no value="$row[0]">
                <input type=hidden name=recid$no value="$row[9]">
                <input type=hidden name=kodesg$no value="$row[3]"></td>
        ~; } else { print qq~
                <td align='left' class="hurufcol" valign="top"><input type='text' name='nmtg$no'  maxlength=20 size=5></td>
                <td align='center' class="hurufcol" valign="top">
                <input type=hidden name=nik$no value="$row[0]">
                <input type=hidden name=recid$no value="$row[9]">
                <input type=hidden name=kodesg$no value="$row[3]"></td>
        ~; }
     } else { print qq~
     <td align='left' class="hurufcol" valign="top"></td>
     <td align='center' class="hurufcol" valign="top"><input type='checkbox'  name='cek$no' value="$row[0]" id='cek$no'>
     <input type=hidden name=nik$no value="$row[0]">
       <input type=hidden name=recid$no value="$row[9]">
       <input type=hidden name=kodesg$no value="$row[3]">
       <input type=hidden name=serid$no value="$row[12]"></td>
     ~; }
     print qq~

     </tr>
     ~;
     $no++;
     $name=$row[0];
     $savetipe=$row[1];
  }

 print qq~
           <tr bgcolor=$colcolor height=20>
           <td colspan=15 align=center><input type="submit" name="save" value="Save" class="huruf1"/>
           <input type=hidden name=ss value="$in{ss}">
           <input type=hidden name=ruleid value="$in{ruleid}">
           <input type=hidden name=nomor value="$no">
           <input type=hidden name=view value="view">
           <input type=hidden name=periode3 value="$in{periode3}">
           <input type=hidden name=periode2 value="$in{periode2}">
          <input type=hidden name=pages value=sc827></td>
          </tr>
          </form>



        </table>
~;
}
if ($s3s[11] eq 'S')
{  print qq ~~;
}
print qq ~
    <hr width="100" />
</center>
~;
}

;
1
