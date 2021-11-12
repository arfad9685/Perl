sub kop021d {

use Date::Calc qw(Add_Delta_Days);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

($month,$day,$year,$weekday) = &jdate(&today());
$month=substr "0$month",-2;
$day=substr "0$day",-2;
$today = $month."/".$day."/".$year;
$pridtoday = genfunckop::getPeriodeKop($today);

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
     <td align=center> <h2 class="hurufcol"> PELUNASAN PINJAMAN </h2> </td>
     <td align=left width=150>&nbsp; </td>
     </tr>
     </table>
     <br/>
~;

if($in{action} eq 'lunas')
{
      for ($i=1; $i<=$in{baris}; $i++)
      { $q1 = $dbk->do("update angsuran set batal='Y', oprupdate='$s3s[0]' where recid='".$in{"recida$i"}."'; ");
        if($q1!=0){ $sukses++; }
      }
      
      if($sukses==$in{baris})
      {
        $q1 = $dbk->do("update pinjaman set lunas='Y', pridlunas='$in{pridlunas}', oprupdate='$s3s[0]' where recid='$in{recidp}';");

#        print qq~INSERT INTO ANGSURAN (PINJAMAN_ID, PERIODE, HRSBAYAR, BUNGA, OPRCREATE, jmlbayar, denda, dtbayar) VALUES
#          ($in{recidp}, '$in{pridlunas}', '$in{totalangsuran}', '$in{totalbunga}', '$s3s[0]', $in{totalall}, $in{denda}, '$in{dtlunas}');~;
#        $q2 = $dbk->do("INSERT INTO ANGSURAN (PINJAMAN_ID, PERIODE, HRSBAYAR, BUNGA, OPRCREATE, jmlbayar, denda, dtbayar) VALUES
#          ($in{recidp}, '$in{pridlunas}', '$in{totalangsuran}', '$in{totalbunga}', '$s3s[0]', $in{totalall}, $in{denda}, '$in{dtlunas}'); ");

#        print qq~UPDATE ANGSURAN set hrsbayar=hrsbayar+$in{totalangsuran}, jmlbayar=jmlbayar+$in{totalall}, dtbayar='$in{dtlunas}', oprupdate='$s3s[0]'
#        where recid = '$in{arecid}';~;
        $q2 = $dbk->do("UPDATE ANGSURAN set hrsbayar=hrsbayar+$in{totalangsuran}, jmlbayar=jmlbayar+$in{totalall}, dtbayar='$in{dtlunas}', oprupdate='$s3s[0]'
        where recid = '$in{arecid}'; ");

        if($q1!=0 and $q2!=0) { print qq~<div class=warning_ok> Sukses Pelunasan </div> ~; }
        else { print qq~<div class=warning_not_ok> Gagal Pelunasan ($q1!=0 and $q2!=0) </div>~; }
      }
      else { print qq~<div class=warning_not_ok> Gagal Pelunasan ($sukses==$in{baris}) </div>~; }
}
else
{
print qq~
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
$query = $dbk->prepare("
select nik, nlengkap, kodecabang  from pinjaman a, getkry k
where a.idlama=k.idlama and lunas='N' order by nlengkap ");
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
  
~;
($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0".$month, -2;
$day = substr "0".$day, -2;
$dt = $month."/".$day."/".$year;
$periodtoday = genfunckop::getPeriodeKop($dt);

print qq~
<script type="text/javascript">
function toProses()
{  var result = confirm("Yakin Pelunasan?");
        if (result==true) {
         with(document.lunas)
          {  action.value='lunas';
             submit();
          }
         }
}
</script>
<form action="/cgi-bin/kopbox.cgi" method="post" name='lunas'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop021d>
  <input type=hidden name=action value=''>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> <input type=text name=nikgo id=nikgo value="$in{nikgo}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Tgl Pelunasan </td>
    <td class="hurufcol"> <input class='huruf1' name="dtlunas" type="text" id="dtlunas" size="12" maxlength="12" value="$in{dtlunas}" />
       <img src="/jscalendar/img.gif" id="trigger4" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtlunas",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger4"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script> </td>
  </tr>
<!--  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Periode Pelunasan </td>
    <td class="hurufcol"> <select id=pridlunas name=pridlunas>
~;
$query = $dbp->prepare("select recid from periodsc where recid>'$periodtoday'");
$query->execute();
while (@rec = $query->fetchrow_array())
{  print qq~ <option value='$rec[0]'> $rec[0]</option>~ ;
}
print qq~
    </select> </td>
  </tr>-->
   <tr>
    <td colspan=2 align=center><input type='submit' name='detil' value='Cek Angsuran'><br/>
     ~;
if($in{detil})
{
  $in{nikgo} = substr $in{nikgo},0,9;
  $in{nikgo} = uc $in{nikgo} ;
  $in{dtlunas} = genfuncpyl::formatMDY($in{dtlunas});
  ($m,$daylunas,$y) = genfuncpyl::getMdy($in{dtlunas});
  $in{pridlunas} = genfunckop::getPeriodeKop($in{dtlunas});
  
  $query = $dbk->prepare("
  select a.periode, hrsbayar, bunga, p.recid, a.recid, jmlpengajuan, masacicil, p.recid from pinjaman p, angsuran a, getkry k where
   p.recid=a.pinjaman_id and k.idlama = p.idlama  and nik='$in{nikgo}' and (k.aktif='Y' or k.aktif='Z')
   and lunas='N'  and jmlbayar=0 order by a.periode"); #and a.periode>='$in{pridlunas}'
#   print "
#  select a.periode, hrsbayar, bunga, p.recid, a.recid, jmlpengajuan, masacicil, p.recid from pinjaman p, angsuran a, getkry k where
#   p.recid=a.pinjaman_id and k.idlama = p.idlama  and nik='$in{nikgo}' and (k.aktif='Y' or k.aktif='Z')
#   and lunas='N'  and jmlbayar=0 order by a.periode";
  $query->execute();
  $i=1;
  while(@rec = $query->fetchrow_array())
  { if($i==1)
    { print qq~<input type=hidden name=recidp value='$rec[3]'>~;
      $recidp=$rec[3];
      $pinjaman = $rec[5];
      $jmlp = genfuncpyl::ribuan($rec[5]);
      print qq~
     <table width=700 border=1 cellspacing=0 cellpadding=2>
      <tr bgcolor=$dark  class="hurufcol">
        <td width=150><b>Jumlah Pinjaman</b></td>
        <td bgcolor=$colcolor>$jmlp</td>
      </tr>
      <tr bgcolor=$dark  class="hurufcol">
        <td><b>Masa Cicilan</b></td>
        <td bgcolor=$colcolor>$rec[6] bulan</td>
      </tr>
     </table><br/>

     <b>Angsuran Yang Telah Dibayarkan</b>
     <table width=700 border=1 cellspacing=0 cellpadding=2>
      <tr bgcolor=$dark  class="hurufcol">
        <td align=center><b>No.</b></td>
        <td align=center><b>Periode</b></td>
        <td align=center><b>Angsuran</b></td>
        <td align=center><b>Bunga</b></td>
        <td align=center><b>Denda</b></td>
        <td align=center><b>Subtotal</b></td>
      </tr>
     ~;

     $q2= $dbk2->prepare("select periode, hrsbayar, bunga, denda, jmlbayar, dtbayar, recid from angsuran where pinjaman_id=$rec[7] and  jmlbayar>0  order by periode");
     $q2->execute();
     $no=1; $arecid=0;
     while(@rec2 = $q2->fetchrow_array())
     { $arecid=$rec2[6];
       $hrsbyr = genfuncpyl::ribuan($rec2[1]);
       $bunga1 = genfuncpyl::ribuan($rec2[2]);
       $denda1 = genfuncpyl::ribuan($rec2[3]);
       $jmlbyr = genfuncpyl::ribuan($rec2[4]);
       $totalhrsbyr+= $rec2[1];
       $totalbunga1+= $rec2[2];
       $totaldenda1+= $rec2[3];
       $totaljml += $rec2[4];
       print qq~
       <tr bgcolor=$colcolor  class="hurufcol">
        <td align=center>$no</td>
        <td align=center>$rec2[0]</td>
        <td align=right>$hrsbyr</td>
        <td align=right>$bunga1</td>
        <td align=right>$denda1</td>
        <td align=right>$jmlbyr</td>
      </tr>~;
        $no++;
     }
     $txthrsbyr = genfuncpyl::ribuan($totalhrsbyr);
     $txtbunga = genfuncpyl::ribuan($totalbunga1);
     $txtdenda = genfuncpyl::ribuan($totaldenda1);
     $txtjmlbyr = genfuncpyl::ribuan($totaljml);
     print qq~
     <tr bgcolor=$dark  class="hurufcol">
        <td align=center colspan=2><b>TOTAL</b></td>
        <td align=right><b>$txthrsbyr</b></td>
        <td align=right><b>$txtbunga</b></td>
        <td align=right><b>$txtdenda</b></td>
        <td align=right><b>$txtjmlbyr</b></td>
      </tr>
      </table><br/>
      
     <b>Sisa Angsuran Yang BELUM Dibayarkan</b>
     <table width=700 border=1 cellspacing=0 cellpadding=2>
      <tr bgcolor=$dark  class="hurufcol">
        <td align=center><b>No.</b></td>
        <td align=center><b>Periode</b></td>
        <td align=center><b>Angsuran</b></td>
        <td align=center><b>Bunga</b></td>
        <td align=center><b>Subtotal</b></td>
      </tr>~;

    }
    else { $rec[2]=0; }
    
    if($i%2==1){ $bg=$colcolor; }
    else { $bg=$colcolor2; }
    $txtangsuran = genfuncpyl::ribuan($rec[1]);
    $txtbunga = genfuncpyl::ribuan($rec[2]);
    $txtsubtotal = genfuncpyl::ribuan($rec[1]+$rec[2]);
    $totalangsuran +=$rec[1];
    $totalbunga +=$rec[2];
    $total +=($rec[1]+$rec[2]);

    print qq~  <input type=hidden name=recida$i value='$rec[4]'>
    <tr bgcolor=$bg  class="hurufcol">
        <td align=center>$i</td>
        <td align=center>$rec[0]</td>
        <td align=right>$txtangsuran</td>
        <td align=right>$txtbunga</td>
        <td align=right><b>$txtsubtotal</b></td>
      </tr>
        ~;
     $i++;
  }

  $totalbunga=0; #karena bunga yg dikenakan hny bulan ini dan sudah dibayar ketika bayar iuran manual
  $total = $totalangsuran;
  $i--;
  $txtang = genfuncpyl::ribuan($totalangsuran);
  $txtbunga = genfuncpyl::ribuan($totalbunga);
  $txttotal = genfuncpyl::ribuan($total);
  print qq~ <tr bgcolor=$dark  class="hurufcol">
        <td align=left colspan=2><b>TOTAL </b></td>
        <td align=right><b>$txtang</b></td>
        <td align=right><b>$txtbunga</b></td>
        <td align=right><b>$txttotal</b></td>
      </tr>
      </table>
    </td>
  </tr>
  ~;
  $denda=0;
  if($daylunas<=5){ $subqd=" and periode<'$pridtoday' "; }
  else { $subqd=" and periode<='$pridtoday' "; }
  $query = $dbk->prepare("
    select datediff(day, cast( (substring (periode from 6 for 2)||'/05/'||substring(periode from 1 for 4)) as date), date '$in{dtlunas}')
   from angsuran where pinjaman_id=$recidp $subqd and jmlbayar=0");
  $query->execute();
  @rec = $query->fetchrow_array();
  if($rec[0]){
  $denda = $rec[0] * 0.01 * $pinjaman /100;
  $denda=0;
  }

  $totalall=$denda+$total;
  $txtdenda = genfuncpyl::ribuan($denda);
  $txttotalp = genfuncpyl::ribuan($totalall);
  print qq~
   <tr bgcolor=$dark class=hurufcol style='padding:2px;border-bottom:1px solid;'>
    <td><b>Denda</b></td>
    <td align=right><b>$txtdenda</b></td>
   </tr>
   <tr bgcolor=$dark class=hurufcol  style='padding:2px;border-bottom:1px solid;'>
    <td><b>TOTAL PELUNASAN</b></td>
    <td align=right><b>$txttotalp </b> </td>
   </tr>
    <tr >
    <td colspan=2 align=center class=hurufcol>
    <input type=hidden name=denda value='$denda'>
    <input type=hidden name=totalall value='$totalall'>
    <input type=hidden name=pridlunas value='$in{pridlunas}'>
    <input type=hidden name=baris value='$i'>
    <input type=hidden name=totalangsuran value='$totalangsuran'>
    <input type=hidden name=totalbunga value='$totalbunga'>
    <input type=hidden name=arecid value='$arecid'> arecid = $arecid
    Note : Total Bunga di-nolkan karena Bunga sudah dibayar di Bayar Iuran Manual<br/>&nbsp;
   ~;

  if($in{detil} && $i>=1){ print qq~<br/> <input type='button' name='pelunasan' value='Pelunasan' onClick='toProses()'> ~; }
    print qq~</td>
  </tr>
  </table>
  </form>    ~;

}#end if $in{detil}


}

print qq ~
    <hr width="100" />
</center>
~;
}

sub hitungcicil {
    ($jumlah, $cicil) = @_;
    $angsuran = $jumlah/$cicil;
    $sisapinjaman = $jumlah;
    
    for ($i=1; $i<=$cicil; $i++)
    { $bunga[$i]=$sisapinjaman*0.01;
      $sisapinjaman = $jumlah-($i*$angsuran);
    }
    return @bunga;
}
;
1

