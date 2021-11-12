sub kop050a {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Tambah Beli', $s3s[17]);
#genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;




if ($in{action} eq 'add')
{     

@cab=split(/\-/,$in{cabang});
   $kodecab = $cab[0];

 if  ($in{currkry})
   {
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   $query = $dbk->prepare("select NIK from getkry where nik='$nik'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   }
    else { $idlama="0";
    }

     
       $subkolom="", $subvalue="";
 #      if ($in{nominal}) { $subkolom.=",NOMINAL";  $subvalue.=",'$in{nominal}'"; }
       if ($in{dtbeli}) { $subkolom.=",TGL_ORDER";  $subvalue.=",'$in{dtbeli}'"; }
       if ($in{dtbeli2}) { $subkolom.=",TGL_TERIMA";  $subvalue.=",'$in{dtbeli2}'"; }
 #      if ($in{status}) { $subkolom.=",STATUS";  $subvalue.=",'$in{status}'"; }
       
 print "INSERT INTO t_trans_h (NIK,KODESTORE,NOMINAL,STATUS,OPRCREATE $subkolom) VALUES
            ('$idlama','$kodecab','$in{nominal}','1','$s3s[0]' $subvalue );<br/> ";

       $flag = $dbk->do("
        INSERT INTO t_trans_h (NIK,KODESTORE,NOMINAL,STATUS,OPRCREATE $subkolom) VALUES
            ('$idlama','$kodecab','$in{nominal}','1','$s3s[0]' $subvalue);");

		 if($flag!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Pembelian</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Pembelian (1=$flag)</div><br/> ";}

                  
}

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
  </script>

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
    var data = [
~;
$str="";
$query = $dbk->prepare("select nik,nlengkap,kodecabang from getkry where aktif ='Y' order by kodecabang");
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
      source: data
    });
  });
  </script> 
  ~;

print qq~
<script type="text/javascript">
function toSubmit()
{  var result = confirm("Yakin Simpan Pembelian?");
        if (result==true) {
         with(document.add)
          { action.value='add';
            submit();
          }
         }
}
</script>
~;


print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=kop050>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Pembelian</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;


print qq~
$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/siskop.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value='kop050a'>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input name="action" type="hidden" value=''>
  
  <table width='580px' border='0' cellspacing='2' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Cabang </td>
    <td class="hurufcol" ><select name="cabang" class="huruf1" id="cabang">
    <option value=''>ALL</option>~;
$query = $dbk->prepare("select distinct kodecabang, namastore from anggota a, getkry k
where a.idlama=k.idlama order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{cabang} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] - $rec[1] </option>~;
}
print qq~
    </select>
    </td></tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Nama Karyawan </td>
    <td class="hurufcol" bgcolor=$colcolor2>
<input type=text name=currkry id=currkry value="$in{currkry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    </tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Tanggal Order </td>
    <td class="hurufcol" >
     <input name="dtbeli" type="text" id="dtbeli" size="12" maxlength="12" class="huruf1" value="$in{dtbeli}" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtbeli",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
</td>
</tr>

<tr bgcolor=$colcolor height=20>
<td class="hurufcol">&nbsp;Tanggal Terima </td>
<td class="hurufcol" bgcolor=$colcolor2> 
<input name="dtbeli2" type="text" id="dtbeli2" size="12" maxlength="12" class="huruf1" value="$in{dtbeli2}" />
        <img src="/jscalendar/img.gif" id="trigger2" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtbeli2",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger2"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
</td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150>&nbsp;Nominal</td>
    <td class="hurufcol" bgcolor=$colcolor><input type=text name=nominal value='$in{nominal}' class= keyboardInput maxlength="15">
    </td>
  </tr>

</table>

 <input type=button value='Simpan' name="simpan" class="huruf1" onClick="toSubmit();">
</form>
    <hr width="100" />
</center>~;
}

1
