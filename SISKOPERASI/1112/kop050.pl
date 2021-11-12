sub kop050{

&koneksi_kop2;

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Pembelian');


@cab=split(/\-/,$in{cabang});
 $kodecab = $cab[0];
   
if  ($in{currkry})
   {
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   $query = $dbk->prepare("select nik from getkry where nik='$nik'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   }
    else { $idlama="0";
    }



if($in{refund})   
	{
		
	$ref = $dbk->do("UPDATE t_trans_h SET refund='Y',oprupdate='$s3s[0]'
            WHERE recid='$in{row}';");    
	#print "UPDATE t_trans_h SET refund='Y',oprupdate='$s3s[0]' WHERE recid='$in{row}'";

	}

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

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
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> PEMBELIAN</h2> </td>
     ~;
#if ($s3s[11] eq 'S')
    print qq~<td align=right width=100>
      <form method=post action="/cgi-bin/siskop.cgi">
      <input type="submit" name="back" value="Tambah" class="huruf1"/>
      <input name="pages" type="hidden" value=kop050a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td>~;
     print qq~
     </tr>
     </table>
<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
<input type=hidden name=ss value="$in{ss}">
<input type=hidden name=pages value=kop050>
<table>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Cabang </td>
    <td class="hurufcol" ><select name="cabang" class="huruf1" id="cabang">
    <option value=''>ALL</option>~;
$query = $dbk->prepare("select distinct kodecabang, namastore from  getkry k
where aktif='Y' order by kodecabang
");
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
    <td class="hurufcol" width=100> &nbsp;Karyawan </td>
    <td class="hurufcol" >
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
        </script> s.d <input name="dtbeli2" type="text" id="dtbeli2" size="12" maxlength="12" class="huruf1" value="$in{dtbeli2}" />
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
</table>
 
<table>
<tr>
    <td align=center><input type='submit' name='search' value='Search'> </td>
  </tr>
</table>
</form>
~;
print qq ~
<script type="text/javascript">

function toedit(n)
{  with(document.mst)
   { pages.value='kop050e';
     kd.value=n;
     submit();
   }
}
</script>
~;
	

 
if($in{search})
{

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"1150px",
      height:"95%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>
<table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=50> NIK </td>
   <td align='left' class="hurufcol" width=150> Nama </td>
   <td align='left' class="hurufcol" width=100> Kode Store </td>
   <td align='left' class="hurufcol" width=70> Nominal </td>
   <td align='left' class="hurufcol" width=50> Tanggal Order </td>
   <td align='left' class="hurufcol" width=50> Tanggal Terima </td>
   <td align='left' class="hurufcol" width=50> Periode Gaji </td>
   <td align='left' class="hurufcol" width=50> Action</td>
   </tr>
~;

$subq="";
if ($in{cabang}) {$subq.=" and h.kodestore='$kodecab'"; }
if ($in{currkry}){$subq.=" and h.nik='$idlama'"; }
if ($in{dtbeli}){  $subq.=" and h.tgl_order >= '$in{dtbeli}'"; }
if ($in{dtbeli2}) {$subq.=" and h.tgl_order<='$in{dtbeli2}'"; }

$subq = substr $subq,5;
if ($subq) {$subq = "where $subq ";}

#print ("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima
 #from t_trans_h h
 #left join getkry g on g.nik=h.nik
 #left join anggota a on a.idlama=g.idlama
# $subq order by g.nlengkap desc");
 
$q = $dbk->prepare("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima,h.recid,h.post_period,h.refund
 from t_trans_h h
 left join getkry g on g.nik=h.nik
 $subq order by g.nlengkap,h.tgl_terima");
$q->execute();

$no=1;
$tmpkat = '';

while (@row = $q->fetchrow_array())
{  
$btn="";
if($row[8]== 'null')
{
 $btn.="<input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[7]');\">&nbsp;"; 
}
 else
 {
	 $btn.="<input type='submit'  name='refund' value='Refund' class='huruf1' >&nbsp;"; 
	 

print qq~	
<form action="/cgi-bin/siskop.cgi" >
<input type=hidden name=ss value="$in{ss}">
<input type=hidden name=pages value="kop050">
<input type=hidden name=row value="$row[7]">
</form>
	  ~;
 }
 
if($row[9] eq 'Y')
{
	$btn='';
}

 
  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  

 
  print qq~
 
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td class="hurufcol" valign="top">$row[0]</td>
     <td class="hurufcol" valign="top">$row[1]</td>
     <td class="hurufcol" valign="top">$row[3]</td>
     <td align='right' class="hurufcol" valign="top">$row[4]</td>
     <td class="hurufcol" valign="top">$row[5]</td>
     <td class="hurufcol" valign="top">$row[6]</td>
	 <td class="hurufcol" valign="top">$row[8]</td>
	 <td align='center' valign="top">$btn </td>
  </tr> 
 </form>
 <form action="/cgi-bin/siskop.cgi" >
	  <input type=hidden name=ss value="$in{ss}">
	  <input type=hidden name=pages value="kop050">
	  <input type=hidden name=row value="$row[7]">
</form>
	  	 	
  ~;
   $no++;
  $tmpkat=$record[3];
  
  
}

print qq ~</table>
~;

}
print qq ~</form>~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

