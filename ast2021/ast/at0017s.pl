sub at0017s {

genfuncast::view_header($in{ss}, $s3s[2], 'Serah Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

&koneksi_ast2;
@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

$maxbaris = 10;

if ($in{action} eq 'add')
{  $sukses=0;
   $in{"ket"}=~ s/\'/\ /g;
   $in{"ket"}=~ s/\"/\ /g;
   $in{"ket"}=uc $in{ket};
   if(!$in{dtst}) { $wrn = "<li>Tgl Serah harus diisi</li>"; }
   if(!$in{cabang} and !$in{kry}) { $wrn = "<li>Karyawan/Cabang Tujuan harus diisi</li>"; }
   if(!$in{"item1"}) { $wrn = "<li>Item 1 Harus Diisi</li>"; }

   $jmlserah=0;
   for ($i=1; $i<=$maxbaris; $i++)
   {   if($in{"item$i"}){$jmlserah++;}
   }
   if($jmlserah==0) { $wrn = "<li>Belum Ada Inventori yang Diisi </li>"; }

   if($wrn)
   { $warning ="<div class=warning_not_ok>Isilah Field di bawah dengan benar: <ul> $wrn </ul> </div>";
   }
   else
   {
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

     @cab=split(/\-/,$in{cabang});
     $kodecab = $cab[0];

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

     $upstokfield = "serah";
     if($in{dthrskembali})
     { $addfield = ", flagpinjam, dthrskembali";
       $addvalue = ", 'Y', '$in{dthrskembali}'";
       $addupinv = " , flagpinjam='Y' ";
       $upstokfield = "pnjserah";
     }
     
#     if($s3s[0] eq 'XTIN'){ print qq~INSERT INTO KIRIMH (RECID, NOSURAT, DTKIRIM, CABANG_TUJ, IDLAMA_TUJ, OPRCREATE, JENIS, ket  $addfield) VALUES
#     ($recid, '$nosurat', '$in{dtst}', '$kodecab', '$idlama', '$s3s[0]', 'S', '$in{ket}' $addvalue);<br/>~; }
     $q1 = $dba1->do("INSERT INTO KIRIMH (RECID, NOSURAT, DTKIRIM, CABANG_TUJ, IDLAMA_TUJ, OPRCREATE, JENIS, ket  $addfield) VALUES
     ($recid, '$nosurat', '$in{dtst}', '$kodecab', '$idlama', '$s3s[0]', 'S', '$in{ket}' $addvalue);");

     if($q1!=0)
     {
       #3. insert kirimd dan  update currcabang & curridlama di INVENTORI
       $jml=0;
       for ($i=1; $i<=$maxbaris; $i++)
       { if($in{"item$i"})
         { @item=split(/\-/,$in{"item$i"});
           
           $huruf6kode = substr $item[0],0,6;
           $subq="";
           if($huruf6kode eq 'PCDSKT'){  $subq=" or groupkode='$item[0]' ";  }
           
           $query = $dba2->prepare("select currcabang, curridlama, kondisi, keterangan, kode from inventori where kode='$item[0]' $subq ");
           $query->execute();
           while (@row = $query->fetchrow_array())
           {
             $jml++;
#       if($s3s[0] eq 'XTIN'){ print qq~INSERT INTO KIRIMD (KIRIMID, KODEINV, CABANG_ASAL, IDLAMA_ASAL, OPRCREATE,  KONDISI_ASAL, ket) VALUES
#             ($recid, '$row[4]', '$row[0]', $row[1], '$s3s[0]', '$row[2]', '$row[3]');<br/>
#             update inventori set currcabang='$kodecab', curridlama='$idlama', oprupdate='$s3s[0]', dtlastkirim='$in{dtst}'
#                 $addupinv where kode='$row[4]'; <br/>
#             update stok set $upstokfield=$upstokfield+1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;<br/>     ~; }
             $q1 = $dba1->do("INSERT INTO KIRIMD (KIRIMID, KODEINV, CABANG_ASAL, IDLAMA_ASAL, OPRCREATE,  KONDISI_ASAL, ket) VALUES
             ($recid, '$row[4]', '$row[0]', $row[1], '$s3s[0]', '$row[2]', '$row[3]');");
             if($q1!=0)
             { $q2 = $dba1->do("update inventori set currcabang='$kodecab', curridlama='$idlama', oprupdate='$s3s[0]', dtlastkirim='$in{dtst}'
                 $addupinv where kode='$row[4]';");
               $jenisinv = substr $row[4],0,6;
               $in{dtst} = genfuncast::formatMDY($in{dtst});
               ($m,$d,$y)=genfuncast::getMdy($in{dtst});
               $m=substr "0$m",-2;
               $periode = $y."-".$m;
               if($q2!=0)
               { $q3 = $dba1->do("update stok set $upstokfield=$upstokfield+1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;");
                 if($q3!=0){ $qsukses++; }
               }
             }
           }
         }
       }

#       if($s3s[0] eq 'XTIN'){ print qq~$qsukses==$jml <br/>~; }

       if($qsukses==$jml){ $warning = "<div class=warning_ok>Sukses Simpan Serah Inventori dengan No. Surat : '$nosurat' -
       <a class=huruflink2 href='sisasset.cgi?pages=at0017&recidprint=$recid&ss=$in{ss}'>Print Sekarang</a></div>"; $sukses=1;  }
       else
       {  for ($i=1; $i<=10; $i++)
          { if($in{"item$i"})
            {  @item=split(/\-/,$in{"item$i"});
               $dba1->do("update inventori set currcabang='MWSMALL', curridlama=0, dtlastkirim=null, flagpinjam='N',
                oprupdate='$s3s[0]' where kode='$item[0]'; ");
            }
          }
          $dba1->do("delete from kirimd where kirimid=$recid; ");
          $dba1->do("delete from kirimh where recid=$recid; ");
          $warning = "<div class=warning_not_ok>GAGAL Simpan Serah Inventori </div>"; $sukses=0;
       }
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
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where (kodecabang like 'C%' or sisasset='Y') order by kodecabang");
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
         with(document.add)
          { action.value='add';
             submit();
          }
         }
}
</script>

<script language="javascript">
function detil(str) {
   if (str=="") {
    document.getElementById("txtHint").innerHTML="";
    return;
  }
  if (window.XMLHttpRequest) {
    // code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp=new XMLHttpRequest();
  } else { // code for IE6, IE5
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
  
//  alert (str) ;
  xmlhttp.onreadystatechange=function() {
//   alert ('state='+xmlhttp.readyState);
//   alert ('status='+xmlhttp.status);
     if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      obj=document.getElementById("txtHint");
      obj.innerHTML=xmlhttp.responseText;

      resultstr = xmlhttp.responseText;
      arr = resultstr.split(',');
      for (i=2; i<arr.length; i++)
      {  document.getElementById("item"+i).value=arr[i-2];
      }
    }
  }
  xmlhttp.open("GET","ast/at0017sd.pl?"+str,true);
  xmlhttp.send();
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
     <td align=center> <h2 class="hurufcol">Serah Inventori</h2> </td>
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
  <input type=hidden name=pages value=at0017s>
  <input type=hidden name=action value=''>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='1000px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tgl Serah </td>
    <td class="hurufcol" colspan=2> <input name="dtst" type="text" id="dtst" size="12" maxlength="12" class="huruf1" value="$in{dtst}" />
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
    <td class="hurufcol" colspan=2>
    <input type=text name=kry id=kry value="$in{kry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     / Cabang Store :
    <input type=text name=cabang id=cabang value="$in{cabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Tgl Harus Kembali : </td>
    <td class="hurufcol" colspan=2><input name="dthrskembali" type="text" id="dthrskembali" size="12" maxlength="12" class="huruf1" value="$in{dthrskembali}" />
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
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Keterangan : </td>
    <td class="hurufcol" colspan=2>
    <input type=text name=ket id=ket value="$in{ket}" class=huruf1 size=35 maxlength="30" style="text-transform: uppercase">
     </td>
    </tr>
~;

for ($i=1; $i<=$maxbaris; $i++)
{
  if($i==1)
  { print "  <tr bgcolor=$colcolor2 height=20>
    <td class='hurufcol'> &nbsp;Inventori $i </td>
    <td class='hurufcol' width=200>
    <input type=text name=item$i id=item$i value='".$in{"item$i"}."' class=huruf1 size=60 maxlength=50 style='text-transform: uppercase'
      onChange=\"detil('ss=$in{ss}&item='+this.value);\">
    </td><td class=hurufcol rowspan=$maxbaris valign=top> <div id=\"txtHint\">N/A</div></td>
    </tr>";
  }
  else
  {
    print " <tr bgcolor=$colcolor2 height=20>
    <td class='hurufcol'> &nbsp;Inventori $i </td>
    <td class='hurufcol' >
    <input type=text name=item$i id=item$i value='".$in{"item$i"}."' class=huruf1 size=60 maxlength=50 style='text-transform: uppercase'>
    </td>
    </tr>
    ";
  }
}

print qq~
</table>


 <input type=button value='Simpan' name="simpan" class="huruf1" onClick="toSubmit();">
</form>~;
}

print qq~
    <hr width="100" />
</center>~;
}


1

