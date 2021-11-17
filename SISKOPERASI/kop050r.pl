sub kop050r{

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Refund');
#genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

if ($in{row})
{	 
#print "select recid from t_trans_h where recid='$in{row}'"; <br/>;
$q1 = $dbk->prepare("select recid from t_trans_h where recid='$in{row}'");
$q1->execute();
@rec = $q1->fetchrow_array(); 
$recid=$rec[0];
 		   		   	
}

if ($in{simpan})
{
      $no2=1;
      until 
      ($no2 > $in{nomor}) {
        $recid=$in{"recid$no2"};
        $flag=$in{"flagcheck$no2"};
        $qtyr=$in{"qtyref$no2"};

    if ($recid and $flag and $qtyr) 
    {   	 
    $ref1 = $dbk->do("UPDATE t_trans_d SET refund='Y',qty_refund='$qtyr',oprupdate='$s3s[0]'
                WHERE recid='$recid';");    

    #print "UPDATE t_trans_d SET refund='Y',qty_refund='$qtyr',oprupdate='$s3s[0]' WHERE recid='$recid'";

    #$ref2 = $dbk->do("INSERT INTO t_trans_d (QTY_REFUND,OPRCREATE) VALUES
		#		              ('$in{qtyref}','$s3s[0]');");
    #print qq~ INSERT INTO t_trans_d (QTY_REFUND,OPRCREATE) VALUES
		#		              ('$in{qtyref}','$s3s[0]');~; 
#
    }
    $no2++;
        
    }
    
    $ref = $dbk->do("UPDATE t_trans_h SET refund='Y',oprupdate='$s3s[0]'
                WHERE recid='$in{row}';");    
    #print "UPDATE t_trans_h SET refund='Y',oprupdate='$s3s[0]' WHERE recid='$in{row}'";   
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
  <td align=center> <h2 class="hurufcol">Refund</h2> </td>
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
#where h.recid='$in{row}'  order by g.nlengkap desc ");
$query = $dbk->prepare("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima,h.recid
 from t_trans_h h
 left join getkry g on g.nik=h.nik
 left join anggota a on a.idlama=g.idlama
 where h.recid='$in{row}' order by g.nlengkap desc ");
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
<form action="/cgi-bin/siskop.cgi" method="post" name='add'>
<input type=hidden name=ss value="$in{ss}">
<input type=hidden name=pages value=kop050r>
<input name="pageid" type="hidden" value='$tmp_tgl[3]'>
<input type=hidden name=row value=$in{row}>  
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
</form>~;

print qq~
<!--<script type='text/javascript' src='/jquery.min.js'></script>-->
<script type='text/javascript' src='/jquery-ui.js'></script>
<link rel="stylesheet" href="/jquery-ui.css">
<br>
<form action="/cgi-bin/siskop.cgi" >
<input type=hidden name=ss value="$in{ss}">

<script type='text/javascript' src='/jquery.min.js'></script>
<td align=center> <h2 class="hurufcol">Daftar Barang</h2> </td>
<table width='550px' border='0' cellspacing='1' cellpadding='2'>
<tr height=20 class="huruf1">
<td align="left" bgcolor=$colcolor class="hurufcol" width=30>Kode Barang</td>
<td align="left" bgcolor=$colcolor class="hurufcol" width=100>Nama Barang</td>
<td align="left" bgcolor=$colcolor class="hurufcol" width=30>Harga Barang</td>
<td align="left" bgcolor=$colcolor class="hurufcol" width=10>Qty</td>
<td align="left" bgcolor=$colcolor class="hurufcol" width=35>Total</td>
<td align="left" bgcolor=$colcolor class="hurufcol" width=10>Qty Refund</td>
<td align="left" bgcolor=$colcolor class="hurufcol" width=5>chk</td>
</tr>   
~;

#print "select d.kodebrg,d.harga,d.qty,d.head_id,mpo.brg_nama,d.total from t_trans_d,d.recid d
#left outer join m_produk_kop mpo on mpo.brg_id=d.kodebrg where d.head_id='$in{row}'";

$q1 = $dbk->prepare("select d.kodebrg,d.harga,d.qty,d.head_id,mpo.brg_nama,d.total,d.recid,d.qty_refund from t_trans_d d
left outer join m_produk_kop mpo on mpo.brg_id=d.kodebrg where d.head_id='$in{row}'");
$q1->execute();
$no=0;	
$tmpkat = '';
while (@record1 = $q1->fetchrow_array())
{
$no++;  
print qq~
<tr class="huruf2" >
<td class="hurufcol" bgcolor=$colcolor2>$record1[0]</td>
<td class="hurufcol" bgcolor=$colcolor2>$record1[4]</td>
<td class="hurufcol" bgcolor=$colcolor2>$record1[1]</td>
<td class="hurufcol" bgcolor=$colcolor2>$record1[2]</td>
<td class="hurufcol" bgcolor=$colcolor2>$record1[5]</td>
<td class="hurufcol" bgcolor=$colcolor2><input type=text name='qtyref$no' value='$record1[7]' size=5 class= keyboardInput maxlength="10"></td>
<td class="hurufcol" bgcolor=$colcolor2>
<input type='checkbox' name='recid$no' value='$record1[6]' id='recid$no'>
<input type=hidden name=flagcheck$no value="$record1[6]"></td>
</tr>
~;

if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }

$tmpkat=$record1[0];	
}

print qq~
<tr class="huruf2">
<td class="hurufcol" bgcolor=$colcolor2 colspan=7 align=center><input type=submit name="simpan" value="Refund" >
          <input type=hidden name=pages value=kop050r>
          <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
          <input type=hidden name=nomor value="$no">
          <input type=hidden name=row value="$in{row}">
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


