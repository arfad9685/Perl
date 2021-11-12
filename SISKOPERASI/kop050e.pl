sub kop050e {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Edit Beli');
#genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

if ($in{simpan})
{  

if  ($in{currkry})
   {
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   $query = $dbk->prepare("select nik, kodecabang from getkry where nik='$nik'");
       $query->execute();
       @row = $query->fetchrow_array();
       $idlama=$row[0];
       $in{cabang}=$row[1];
     }
     else { $idlama="0"; }
	 
	 
 #print qq~ UPDATE t_trans_h SET TGL_ORDER='$in{dtbeli}', TGL_TERIMA='$in{dtbeli2}',NOMINAL='$in{nominal}',oprupdate='$s3s[0]'
  #         WHERE recid='$in{kd}';~; 
			
   if ($in{kd})
   {

		$postall = $dbk->do("UPDATE t_trans_h SET TGL_ORDER='$in{dtbeli}', TGL_TERIMA='$in{dtbeli2}',NOMINAL='$in{nominal}',oprupdate='$s3s[0]'
            WHERE recid='$in{kd}';");
        
        $warning = "<div class='warning_ok'>Sukses Edit Menu</div><br/> ";

   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }

		 
	if ($in{kodebar}  )
   {
	  @brgid=split(/\-/,$in{kodebar});
	  $kdbrg=$brgid[0];
	   $query = $dbk->prepare("select brg_id, brg_nama,harga from m_produk_kop where brg_id='$kdbrg' ");
       $query->execute();
       @row = $query->fetchrow_array(); 
	   $kodebar=$row[0];
	   $in{namabar}=$row[1];
	   $in{harga}=$row[2];
	  }
     else { $kodebar="0"; } 
	 
#print "select recid from t_trans_h where recid='$in{kd}'"; <br/>;

	 $q1 = $dbk->prepare("select recid from t_trans_h where recid='$in{kd}'");
       $q1->execute();
       @rec = $q1->fetchrow_array(); 
	   $recid=$rec[0];
	   
	 
	 $in{total}=$in{harga}*$in{qty};
	 $in{diskon}="0";
	 
	 $subkolom="", $subvalue="";
      if ($in{diskon}) { $subkolom.=",DISKON";  $subvalue.=",'$in{diskon}'"; }
       	
#print qq~ INSERT INTO t_trans_d (HEAD_ID,KODEBRG,HARGA,TOTAL,QTY,OPRCREATE $subkolom) VALUES
#            ('$recid','$kodebar','$in{harga}','$in{total}','$in{qty}','$s3s[0]' $subvalue);~; 
			
	$flag = $dbk->do("
        INSERT INTO t_trans_d (HEAD_ID,KODEBRG,HARGA,TOTAL,QTY,OPRCREATE $subkolom) VALUES
            ('$recid','$kodebar','$in{harga}','$in{total}','$in{qty}','$s3s[0]' $subvalue);");

		 if($flag!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Barang</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Barang </div><br/> ";}
		   		   	
}


if ($in{delete})
{

		$postall = $dbk->do("DELETE FROM t_trans_d WHERE recid='$in{record}'");
		#print "DELETE FROM t_trans_d WHERE recid='$in{record}'";
        if($postall!=0)
        { $warning_del = "<div class='warning_ok'>Sukses Hapus Barang</div><br/> ";}
        else { $warning_del = "<div class='warning_not_ok'>Gagal Hapus Barang</div><br/> ";}

}



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
     <td align=center> <h2 class="hurufcol">Edit Beli</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;

#print ("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima,h.recid
#from t_trans_h h
 #left join getkry g on g.nik=h.nik
 #left join anggota a on a.idlama=g.idlama
 #where h.recid='$in{kd}'  order by g.nlengkap desc ");
$query = $dbk->prepare("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima,h.recid
 from t_trans_h h
 left join getkry g on g.nik=h.nik
 left join anggota a on a.idlama=g.idlama
 where h.recid='$in{kd}' order by g.nlengkap desc ");
$query->execute();
@record = $query->fetchrow_array();

if ($record[0] eq 'W') { $record[0]='Y'; }

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>


$warning
<form action="/cgi-bin/siskop.cgi" method="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop050e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>  
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Karyawan </td>
    <td class="hurufcol" >$record[0] - $record[1]  </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Tanggal Order </td>
    <td class="hurufcol" >
     <input name="dtbeli" type="text" id="dtbeli" size="12" maxlength="12" class="huruf1" value="$record[5]" />
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
<td class="hurufcol"> Tanggal Terima </td>
<td class="hurufcol" bgcolor=$colcolor2> 
<input name="dtbeli2" type="text" id="dtbeli2" size="12" maxlength="12" class="huruf1" value="$record[6]" />
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
    <td class="hurufcol" width=150> Nominal </td>
    <td class="hurufcol" ><input type=text name=nominal value='$record[4]' class=huruf1 maxlength="30" size=35  style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>~;




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
    var data = [
~;

$str="";
$query = $dbk->prepare("select brg_id,brg_nama from m_produk_kop where isaktif='Y' order by 1");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0] - $rec[1]", category: "" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#kodebar").catcomplete({
      delay: 0,
      source: data
    });
      });
  </script>
~;





print qq~

  <br>
  <script type='text/javascript' src='/jquery.min.js'></script>
<td align=center> <h2 class="hurufcol">Daftar Barang</h2> </td>
 <table width='400px' border='0' cellspacing='1' cellpadding='2'>
 <tr height=20 class="huruf1">
      <td align="left" bgcolor=$colcolor class="hurufcol" width=30>Kode Barang</td>
      <td align="left" bgcolor=$colcolor class="hurufcol" width=70>Nama Barang</td>
	  <td align="left" bgcolor=$colcolor class="hurufcol" width=30>Harga Barang</td>
	  <td align="left" bgcolor=$colcolor class="hurufcol" width=30>Qty</td>
	  <td align="left" bgcolor=$colcolor class="hurufcol" width=30>Total</td>
	  <td align="left" bgcolor=$colcolor class="hurufcol" width=30>Action</td>
  </tr>  
  
~;

#print "select d.kodebrg,d.harga,d.qty,d.recid,mpo.brg_nama,d.total from t_trans_d d
#left outer join m_produk_kop mpo on mpo.brg_id=d.kodebrg 
#where d.head_id='$in{kd}'";

$q1 = $dbk->prepare("select d.kodebrg,d.harga,d.qty,d.recid,mpo.brg_nama,d.total from t_trans_d d
left outer join m_produk_kop mpo on mpo.brg_id=d.kodebrg 
where d.head_id='$in{kd}' ");
$q1->execute();
$no=1;	
$tmpkat = '';
while (@record = $q1->fetchrow_array())
{

   #$btn = "
   #<input type='image' src='/images/del.png' name='del$no' value='delete' class='huruf1' onClick=\"validasi('$record[3]');\">"; 

if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  
print qq~
<form method=post action="/cgi-bin/siskop.cgi" >
    <tr class="huruf2">
    <td align=left bgcolor=$colcolor2>$record[0]</td>
    <td align=left bgcolor=$colcolor2>$record[4]</td>
	<td align=left bgcolor=$colcolor2>$record[1]</td>
	<td align=left bgcolor=$colcolor2>$record[2]</td>
	<td align=left bgcolor=$colcolor2>$record[5]</td>
	<td align=left bgcolor=$colcolor2><input type='submit' name='delete' value='Delete' class='huruf1'></td>
    </tr>
	<input type=hidden name=ss value="$in{ss}">
        <input type=hidden name=pages value="kop050e">
        <input type=hidden name=record value="$record[3]">
		<input type=hidden name=kd value=$in{kd}> 
		<input type=hidden name=kodebar value=$in{kodebar}> 
		</form>
    ~; 
$no++;
  $tmpkat=$record[0];	
}
print qq~
<form action="/cgi-bin/siskop.cgi" method="post" name='add'>
<input type=hidden name=ss value="$in{ss}">
 <input type="hidden" name="aa" value="$in{aa}"/>
  <input type=hidden name=pages value=kop050e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}> 
 

    <tr class="huruf2" >
    <td class="hurufcol" bgcolor=$colcolor2 colspan=4>
<input type=text name=kodebar id=kodebar value="$in{kodebar}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
<td class="hurufcol" bgcolor=$colcolor><input type=text name=qty value='$in{qty}' class= keyboardInput maxlength="15"></td>
~; 

print qq~
<td class="hurufcol" bgcolor=$colcolor2><input type=submit name="simpan" value="Add" >
    
        </td>

    </tr>
   </form>

</table>
~;


print qq~
    <hr width="100" />
</center>~;
}


1


