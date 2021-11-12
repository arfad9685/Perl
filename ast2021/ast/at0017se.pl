sub at0017se {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Serah Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if ($in{action} eq 'edit')
{
   if(!$in{dtst}) { $wrn = "<li>Tgl Serah harus diisi</li>"; }
   if(!$in{cabang}) { $wrn = "<li>Cabang Tujuan harus diisi</li>"; }
#   if(!$in{kry}) { $wrn = "<li>Karyawan Tujuan harus diisi</li>"; }

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
       $query = $dba1->prepare("select idlama from getkry where nik='$nik'");
       $query->execute();
       @row = $query->fetchrow_array();
       $idlama=$row[0];
     }
     else { $idlama="0"; }

     $dtst = genfuncast::formatMDY($in{dtst});
     ($m,$d,$y)=genfuncast::getMdy($in{dtst});
     $nm=substr "0$m",-2;
     $ny=substr $y,-2;

     $upstokfield = "serah";
     #1. insert data atas ke KIRIMH jenis=S
     #print qq~update kirimh set dtkirim='$in{dtst}', cabang_tuj='$kodecab', idlama_tuj='$idlama', oprupdate='$s3s[0]' where recid='$in{recidh}';~;
     if($in{dthrskembali})
     { $addup = ", flagpinjam='Y', dthrskembali='$in{dthrskembali}'";  $addupinv = " , flagpinjam='Y' ";  $upstokfield = "pnjserah";
     }
     $q1 = $dba1->do("update kirimh set dtkirim='$in{dtst}', cabang_tuj='$kodecab', idlama_tuj='$idlama', oprupdate='$s3s[0]' $addup where recid='$in{recidh}';");

     if($q1!=0)
     {
       for ($i=1; $i<=$in{barisitemup}; $i++)  #$addupinv
       {  $q1 = $dba1->do("update inventori set currcabang='$kodecab', curridlama='$idlama', oprupdate='$s3s[0]' $addupinv where kode='".$in{"itemup$i"}."';");
          if($q1!=0){ $qsuksesup++; }
       }

       #2. insert kirimd dan  update currcabang & curridlama di INVENTORI
       $jml=0;
       for ($i=1; $i<=10; $i++)
       { if($in{"item$i"})
         { $jml++;
           @item=split(/\-/,$in{"item$i"});
           $q1 = $dba1->do("INSERT INTO KIRIMD (KIRIMID, KODEINV, CABANG_ASAL, IDLAMA_ASAL, OPRCREATE,  KONDISI_ASAL) VALUES
           ($in{recidh}, '$item[0]', '$item[3]', $item[4], '$s3s[0]', '$item[5]');");
           $q2 = $dba1->do("update inventori set currcabang='$kodecab', curridlama='$idlama', oprupdate='$s3s[0]', dtlastkirim='$in{dtst}'
             $addupinv where kode='$item[0]';");
           if($q1!=0 && $q2!=0)
           { $jenisinv = substr $item[0],0,6;
             $q3 = $dba1->do("update stok set $upstokfield=$upstokfield+1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;");
             if($q3!=0){ $qsukses++; }
           }
         }
       }
       if($qsukses==$jml and $qsuksesup==$in{barisitemup}){ $warning = "<div class=warning_ok>Sukses Simpan Serah Inventori </div>"; }
       else { $warning = "<div class=warning_not_ok>Hanya Sukses Insert $qsukses dari $jml item. </div>"; }
     }
     else { $warning = "<div class=warning_not_ok>Gagal Header </div>"; }
     
   }
}

if($in{recidd})
{ $q1 = $dba1->do("update kirimd set batal='Y', oprupdate='$s3s[0]' where recid='$in{recidd}';");
  $q2 = $dba1->do("update inventori set currcabang='MWSMALL', curridlama=null, oprupdate='$s3s[0]', flagpinjam='N' where kode='$item[0]';");
  if($q1!=0 and $q2!=0)
  { $warning = "<div class=warning_ok>Sukses Hapus Item dari Inventori Barang </div>";
  }
  else { $warning = "<div class=warning_not_ok>Gagal Hapus Item dari Inventori  Barang (1=$q1 2=$q2) </div>"; }
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
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where (kodecabang like 'C%' or kodecabang like 'MW%') order by kodecabang");
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
$query = $dba1->prepare("select kode, merek, warna, namajenis, currcabang, curridlama, kondisi, kodeasset, noseri
from inventori i, jenisinv j where i.jenis=j.jenis and (currcabang like 'MW%') order by kode ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]-$rec[2]-$rec[4]-$rec[5]-$rec[6]-$rec[7]-$rec[8]", category: "$rec[3]" },~ ;
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
    \$("#item6").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item7").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item8").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item9").catcomplete({
      delay: 0,
      source: data3
    });
    \$("#item10").catcomplete({
      delay: 0,
      source: data3
    });
  });
  </script>
<script type="text/javascript">
function toSubmit()
{  var result = confirm("Yakin Simpan Penyerahan?");
        if (result==true) {
         with(document.se)
          { action.value='edit';
             submit();
          }
         }
}
</script>~;


print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at0017>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Edit Serah Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;

$query = $dba1->prepare("select dtkirim, nosurat, cabang_tuj, namacabang, idlama_tuj, dthrskembali
from kirimh h, getstruk c
where  h.cabang_tuj=c.kodecabang and h.recid='$in{recidh}' ");
$query->execute();
@record = $query->fetchrow_array();

if($record[4]!=0)
{
 $q = $dba1->prepare("select nik, nlengkap from getkry where idlama='$record[4]'");
 $q->execute();
 @rec = $q->fetchrow_array();
 $kry = $rec[0]."-".$rec[1];
}
print qq~
$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<script type="text/javascript">
function toDelete(n)
{  with(document.se)
   { pages.value='at0017se';
     recidd.value=n;
     submit();
   }
}
</script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='se'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=action value=''>
  <input type=hidden name=pages value=at0017se>
  <input type=hidden name=nosurat value=$record[1]>
  <input type=hidden name=recidh value=$in{recidh}>
  <input type=hidden name=recidd value=>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='900px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;No Surat </td>
    <td class="hurufcol" >$record[1]
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tgl Serah/Terima </td>
    <td class="hurufcol" > <input name="dtst" type="text" id="dtst" size="12" maxlength="12" class="huruf1" value="$record[0]" />
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
    <td class="hurufcol"> &nbsp;Cabang </td>
    <td class="hurufcol" >
    <input type=text name=cabang id=cabang value="$record[2]-$record[3]" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Karyawan </td>
    <td class="hurufcol" >
    <input type=text name=kry id=kry value="$kry" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Tgl Harus Kembali : </td>
    <td class="hurufcol"><input name="dthrskembali" type="text" id="dthrskembali" size="12" maxlength="12" class="huruf1" value="$record[5]" />
        <img src="/jscalendar/img.gif" id="trigger2" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dthrskembali",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger2"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>  <i>*Diisi bila Inventori hanya dipinjamkan sementara</i>
     </td>
    </tr>~;

$query = $dba1->prepare("select kode, merek, warna, namajenis, namacabang, idlama_asal, d.kondisi, d.recid
from kirimd d, inventori i, jenisinv j, getstruk c
where i.jenis=j.jenis and d.kodeinv=i.kode and d.cabang_asal=c.kodecabang  and kirimid=$in{recidh} and d.batal='N'
");
$query->execute();
$no=0;
while(@rec = $query->fetchrow_array())
{
  if($rec[5]!=0)
  {
    $q = $dba2->prepare("select nik, nlengkap from getkry where idlama='$rec[5]'");
    $q->execute();
    @rec2 = $q->fetchrow_array();
  }
  
  $no++;
  print "  <tr bgcolor=$colcolor2 height=20>
    <td class='hurufcol'> &nbsp;Inventori $no </td>
    <td class='hurufcol' >$rec[0]-$rec[1]-$rec[2]-$rec[3] : $rec[6]  dari $rec[4] ($rec2[0]-$rec2[1])
    <input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"toDelete('$rec[7]');\">
    <input type='hidden' name='itemup$no' value='$rec[0]'>
    </td>
    </tr>
";
}
print qq~ <input type='hidden' name='barisitemup' value='$no'>~;

for ($i=$no+1; $i<=10; $i++)
{
print "  <tr bgcolor=$colcolor2 height=20>
    <td class='hurufcol'> &nbsp;Inventori $i </td>
    <td class='hurufcol' >
    <input type=text name=item$i id=item$i value='".$in{"item$i"}."' class=huruf1 size=60 maxlength=50 style='text-transform: uppercase'>
    </td>
    </tr>
";
}

print qq~
</table>

 <input type=button value='Simpan' name="simpan" class="huruf1" onClick="toSubmit();">
</form>
    <hr width="100" />
</center>~;

}
1

