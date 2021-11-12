#!/usr/bin/perl

use CGI;
use DBI;

require "/opt/sarirasa/core/koneksi_str.pl";
require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
&con_ass0;
&con_inv0;

sub add_isp_spk {
   ($nomor,$cab,$tanggal,$brg,$satpro,$rekomen,$satprod,$target,$qtyoh,$prep,$operator,$work) = @_;
   if ($target) {
      @tg = split('/',$tanggal);
      if (length($tg[0])<2) {
        $tg[0]='0'.$tg[0];
      }
      $thnbln=$tg[2].$tg[0];
      if (!$nomor) {
         $insert_isp=$dbh->prepare ("SELECT * FROM SP_ADD_NEW_ISP ('$cab', '$tanggal', '$brg', '$satpro',$rekomen,
                                    '$satprod', $target, $qtyoh, '$prep','$operator','$work')");
         $insert_isp->execute();
         $insert_isp->bind_columns(undef,\$result);
         $insert_isp->fetch();
         $dbh->commit;
         $nomor =$result;
         if ($insert_isp==0) {
            style_module::use_chkerror($dbh);
            return 'Cancel Proses.';            
         } else {
           $insert_chk=$dbh->do ("SELECT * FROM T_SPKISP_$thnbln where SPK_ORDER='$nomor'");            
           $dbh->commit;           
           return $nomor;
         }         
      } else {
        $insert_ispx = $dbh->do("insert into t_spkisp_$thnbln (SPK_ORDER, SPK_TGL, SPK_STOREID, SPK_BRGID, SPK_SATPRO, SPK_REKOMEN, SPK_SATPROD, SPK_TARGET, STK_OH,
        SPK_PREP, OPERATOR,SPK_ADDWORK) VALUES ('$nomor', '$tanggal','$cab','$brg','$satpro',$rekomen,'$satprod',$target,$qtyoh,'$prep','$operator','$work')");
        if ($insert_ispx==0) {
            style_module::use_chkerror($dbh);
            return 'Cancel Proses.';            
        } else {
            $dbh->commit;
            return $nomor;                               
        }        
      }      
   }
}

sub update_stat_isp {
   ($id,$stat,$hasil) = @_;
   $thnbln=style_module::thntgl(6);
   if ($id) {
     if ($stat eq 'Y') {
       $up_menu=$dbh->do("UPDATE T_SPKISP_$thnbln SET SPK_PROSES='$stat',SPK_HASIL=$hasil WHERE RECID=$id");      
     } else { 
       $up_menu=$dbh->do("UPDATE T_SPKISP_$thnbln SET SPK_PROSES='$stat' WHERE RECID=$id");
     }  
     if ($up_menu==0) {
         style_module::use_chkerror($dbh);
          return "canceled";         
     } else {
          return 'Updated.';
     }          
   } 
}

sub check_isp_hold {
   ($store) = @_;
   $tbl_isp=$dbh->prepare("select brgid, brgnama, oh from get_isp_hold('$store')");
   $tbl_isp->execute();
   $txt ="<br><font size=2>";
   while (@rec=$tbl_isp->fetchrow())
  {
    $txt .= "$rec[1] ($rec[0]) -> $rec[2]<br>";
  }
  $txt .="<br><br>Lakukan Koreksi Opname untuk lanjut.<br>Hubungi SOP untuk check resepi.</font><br>";
  return $txt;
}


1;
