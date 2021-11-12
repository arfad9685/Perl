sub at0019 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Report Stok');
genfuncast::validasi_akses($s3s[11], $in{ss});
use Date::Calc qw(Days_in_Month);

@cab=split(/\-/,$in{currcabang});
   $kodecab = $cab[0];

if  ($in{currkry})
   {
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   #print "$in{currkry} select idlama from getkry where nik='$nik'";
   $query = $dba1->prepare("select idlama from getkry where nik='$nik'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   }
    else { $idlama="0";
    }

print qq~
<!--<script type='text/javascript' src='/jquery.min.js'></script>-->
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

  \$(function(\$) {
    var data1 = [
~;
$str="";
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~  { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];


    \$("#currcabang").catcomplete({
      delay: 0,
      source: data1
    });
  });
  </script>
~;

print qq~
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
  \$(function(\$) {
    var data2 = [
~;
$str="";
$query = $dba1->prepare("select nik,nlengkap,kodecabang from getkry order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#currkry").catcomplete({
      delay: 0,
      source: data2
    });
  });
  </script>


  <script>
  \$(function(\$) {
    var data3 = [
~;
$str="";
$query = $dba1->prepare("select kode, merek, namajenis from inventori i, jenisinv j where i.jenis=j.jenis order by kode");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#kodeinv").catcomplete({
      delay: 0,
      source: data3
    });
  });
  </script>
  ~;

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>

     &nbsp;  &nbsp;

     <td align=center> <h2 class="hurufcol"> REPORT STOK</h2> </td>

     </tr>
     </table>
~;

#if($s3s[0] eq 'XTIN')
#{
#  ($month,$day,$year,$weekday) = &jdate(&today());
#  $month = substr "0".$month, -2;
#  $pridtoday = $year."-".$month;
#  if($pridtoday ne $lastprid)
#  { print qq~<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
#<input type=hidden name=ss value="$in{ss}">
#<input type=hidden name=pages value=at0019>
#<input type=hidden name=lastprid value='$lastprid'>
#<input type=hidden name=nextprid value='$pridtoday'>
#<input type='submit' name='gennext' value='Generate Next Periode = $pridtoday'>
#</form>
#~;
#  }
#  else { print qq~Tombol Generate Stok Tidak Tersedia (Karena Periode Hari Ini masih = Last Periode)<br/>&nbsp;<br/>   ~; }
#  
#  if($in{gennext})
#  { $q1 = $dba1->do("INSERT INTO STOK (periode, jenisinv, stokawal, oprcreate)
#    select '$in{nextprid}', j.jenis, coalesce(stokakhir,0), '$s3s[0]'
#    from jenisinv j left outer join stok s on j.jenis=s.jenisinv and periode='$in{lastprid}'");
#    if ($q1!=0){ print qq~<div class=warning_ok>Sukses Generate Periode Stok Baru '$in{nextprid}' </div>~; }
#    else { print qq~<div class=warning_not_ok>GAGAL Generate Periode Stok Baru '$in{nextprid}' </div>~; }
#  }
#}

if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function validasi(n)
{
      var result = confirm("Are you sure to delete?");
        if (result==true) {
          with(document.mst)
          { pages.value='at0019';
            kd.value=n;
           submit();
          }
        }
}
function validasi2(n)
{
      var result = confirm("Are you sure to delete?");
        if (result==true) {
          with(document.mst)
          { pages.value='at0019';
            child.value=n;
           submit();
          }
        }
}
function toedit(n)
{  with(document.mst)
   { pages.value='at0019e';
     kd.value=n;
     submit();
   }
}
function toaddsub(n)
{  with(document.mst)
   { pages.value='at0019b';
     kd.value=n;
     submit();
   }
}
</script>
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0019>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
 <input type=hidden name='kd'>
 <input type=hidden name='child'>
 <input type=hidden name='parent'>
 <input type=hidden name='action' value='delete'>
 ~;
}

#if($in{search})
{
print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
  <table width='850px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='left' class="hurufcol" width=80> Kode Inventori </td>
   <td align='left' class="hurufcol" width=110> Jenis Inventori </td>
   <td align='center' class="hurufcol" width=60><b> Stok Awal </b></td>
   <td align='center' class="hurufcol" width=60> Masuk </td>
   <td align='center' class="hurufcol" width=60> Terima </td>
   <td align='center' class="hurufcol" width=100> Pinjaman Terima </td>
   <td align='center' class="hurufcol" width=60> Serah </td>
   <td align='center' class="hurufcol" width=100> Pinjaman Serah </td>
   <td align='center' class="hurufcol" width=50><b> Stok Akhir </b></td>
  </tr>
~;

$subq="";

#if ($in{periode}) {$subq.=" and s.periode='$in{periode}'"; }
#if ($in{jen}) {$subq.=" and k.klpjenis='$in{jen}'"; }
#$subq = substr $subq,5;
#if ($subq) {$subq = "where $subq ";}

#@tmp =  split(/\-/, $in{periode});
#$year = $tmp[0];
#$month = $tmp[1];
#$days = Days_in_Month($year,$month);
#$dt1 = $month."/1/".$year;
#$dt2 = $month."/$days/".$year;

$q = $dba1->prepare("select j.jenis,j.namajenis,s.stokawal,s.masuk,s.terima,s.pnjterima,s.serah,s.pnjserah,s.stokakhir
from stok s
left outer join jenisinv j on j.jenis=s.jenisinv
left outer join klpjenisinv k on k.klpjenis=j.klpjenis
order by j.jenis");
$q->execute();
$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{ if($row[2]>0){ $row[2]=qq~<a class=huruflink href="sisasset.cgi?pages=at0010&jen=$row[0]&ss=$in{ss}" target='_blank'>$row[2]</a>~; }
  if($row[3]>0){ $row[3]=qq~<a class=huruflink href="sisasset.cgi?pages=at0010&jen=$row[0]&ss=$in{ss}" target='_blank'>$row[3]</a>~; }
  if($row[4]>0){ $row[4]=qq~<a class=huruflink href="sisasset.cgi?pages=at0012&jenisinv=$row[0]&kembali=N&ss=$in{ss}" target='_blank'>$row[4]</a>~; }
  if($row[5]>0){ $row[5]=qq~<a class=huruflink href="sisasset.cgi?pages=at0012&jenisinv=$row[0]&kembali=K&ss=$in{ss}" target='_blank'>$row[5]</a>~; }
  if($row[6]>0){ $row[6]=qq~<a class=huruflink href="sisasset.cgi?pages=at0017&jenisinv=$row[0]&pinjam=N&ss=$in{ss}" target='_blank'>$row[6]</a>~; }
  if($row[7]>0){ $row[7]=qq~<a class=huruflink href="sisasset.cgi?pages=at0017&jenisinv=$row[0]&pinjam=Y&ss=$in{ss}" target='_blank'>$row[7]</a>~; }

 if($no%2==1){ $bg=$colcolor; }
 else { $bg=$colcolor2; }
 print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td class="hurufcol" valign="top">$row[0]</td>
     <td class="hurufcol" valign="top">$row[1]</td>
     <td align='right' class="hurufcol" valign="top">$row[2]</td>
     <td align='right' class="hurufcol" valign="top">$row[3]</td>
     <td align='right' class="hurufcol" valign="top">$row[4]</td>
     <td align='right' class="hurufcol" valign="top">$row[5]</td>
     <td align='right' class="hurufcol" valign="top">$row[6]</td>
     <td align='right' class="hurufcol" valign="top">$row[7]</td>
     <td align='right' class="hurufcol" valign="top">$row[8]</td>
   </tr>
  ~;
  $no++;
  $tmpkat=$row[0];
}

print qq ~</table>
~;
}

if ($s3s[11] eq 'S')
{  print qq ~</form>~;
}
print qq ~
    <hr width="100" />
</center>
~;
}

;
1

