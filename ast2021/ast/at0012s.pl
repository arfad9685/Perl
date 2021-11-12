sub at0012s {

genfuncast::view_header($in{ss}, $s3s[2], 'Serah Barang');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if ($in{simpan})
{  $sukses=0;
   if(!$in{dtst}) { $wrn = "<li>Tgl Serah harus diisi</li>"; }
   if(!$in{cabang} and !$in{kry}) { $wrn = "<li>Karyawan/Cabang Tujuan harus diisi</li>"; }
   if(!$in{"item1"}) { $wrn = "<li>Item 1 Harus Diisi</li>"; }

   if($wrn)
   { $warning ="<div class=warning_not_ok>Isilah Field di bawah dengan benar: <ul> $wrn </ul> </div>";
   }
   else
   {
     @cab=split(/\-/,$in{cabang});
     $kodecab = $cab[0];

     if ($in{kry})
     {
       @kry=split(/\-/,$in{kry});
       $nik = $kry[0];
   #print "$in{kry} select idlama from getkry where nik='$nik'";
       $query = $dba1->prepare("select idlama, kodecabang from getkry where nik='$nik'");
       $query->execute();
       @row = $query->fetchrow_array();
       $idlama=$row[0];
       $in{cabang}=$row[1];
     }
     else { $idlama="0"; }

#     $dtst = genfuncast::formatMDY($in{dtst});
#     ($m,$d,$y)=genfuncast::getMdy($in{dtst});
#     $nm=substr "0$m",-2;
#     $ny=substr $y,-2;

#     #1. generate no surat
#     $query = $dba1->prepare("select count(*) from kirimh where nosurat like '$ny$nm%' ");
#     $query->execute();
#     @row = $query->fetchrow_array();
#     $ctr = $row[0]+1;
#     $ctr = substr "0000$ctr",-5;
#     $nosurat = "$ny$nm$ctr";

     $nosurat = genfuncast::generate_nosurats($in{dtst}, $dba1);
      
     #2. insert data atas ke KIRIMH jenis=S
     $query = $dba1->prepare("select max(recid) from kirimh  ");
     $query->execute();
     @row = $query->fetchrow_array();
     if($row[0]){ $recid=$row[0]+1; }
     else { $recid=1; }
     $q1 = $dba1->do("INSERT INTO KIRIMH (RECID, NOSURAT, DTKIRIM, CABANG_TUJ, IDLAMA_TUJ, OPRCREATE, JENIS) VALUES
     ($recid, '$nosurat', '$in{dtst}', '$kodecab', '$idlama', '$s3s[0]', 'S');");

     if($q1!=0)
     {
       #3. insert kirimd dan  update currcabang & curridlama di INVENTORI
       $jml=0;
       for ($i=1; $i<=10; $i++)
       { if($in{"item$i"})
         { $jml++;
           @item=split(/\-/,$in{"item$i"});
           $q1 = $dba1->do("INSERT INTO KIRIMD (KIRIMID, KODEINV, CABANG_ASAL, IDLAMA_ASAL, OPRCREATE,  KONDISI_ASAL) VALUES
           ($recid, '$item[0]', '$item[3]', $item[4], '$s3s[0]', '$item[5]');");
           $q2 = $dba1->do("update inventori set currcabang='$kodecab', curridlama='$idlama', oprupdate='$s3s[0]' where kode='$item[0]';");
           if($q1!=0 && $q2!=0){ $qsukses++; }
         }
       }
       if($qsukses==$jml){ $warning = "<div class=warning_ok>Sukses Simpan Serah Barang </div>"; $sukses=1;  }
     }
     else { $warning = "<div class=warning_ok>Gagal Header </div>"; }
     
   }
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
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where kodecabang like 'C%' order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~  { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];


    \$("#cabang").catcomplete({
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
$query = $dba1->prepare("select nik,nlengkap,kodecabang,namacabang from getkry
where (kodecabang not like 'C%' or (kodecabang like 'C%' and posisi like '%PJ%' )  )
order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0] - $rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#kry").catcomplete({
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
$query = $dba1->prepare("select kode, merek, warna, namajenis, currcabang, curridlama, kondisi
from inventori i, jenisinv j where i.jenis=j.jenis and currcabang='MISH_ALL' ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]-$rec[2]-$rec[4]-$rec[5]-$rec[6]", category: "$rec[3]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#item1").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item2").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item3").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item4").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item5").catcomplete({
      delay: 0,
      source: data3
    });
  });
  </script>
~;


print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at0012>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Serah Barang</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>   $warning
~;

if($sukses==0)
{

print qq~

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0012s>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='1000px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tgl Serah/Terima </td>
    <td class="hurufcol" > <input name="dtst" type="text" id="dtst" size="12" maxlength="12" class="huruf1" value="$in{dtst}" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtst",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Karyawan HO-DP : </td>
    <td class="hurufcol">
    <input type=text name=kry id=kry value="$in{kry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     / Cabang Store :
    <input type=text name=cabang id=cabang value="$in{cabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    </tr>
~;
for ($i=1; $i<=10; $i++)
{
print "  <tr bgcolor=$colcolor2 height=20>
    <td class='hurufcol'> &nbsp;Inventori $i </td>
    <td class='hurufcol' >
    <input type=text name=item$i id=item$i value='".$in{"item$i"}."' class=huruf1 size=40 maxlength=50 style='text-transform: uppercase'>
    </td>
    </tr>
";
}

print qq~
</table>


 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>~;
}

print qq~
    <hr width="100" />
</center>~;
}


1

