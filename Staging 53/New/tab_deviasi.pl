#!/usr/bin/perl

use CGI;
use DBI;

require "/opt/sarirasa/core/koneksi_str.pl";
require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
&con_ass0;
&con_inv0;



sub update_audit_dev {
   ($idadj,$adjust) = @_;
   
   if ($idadj) {
     
       $up_menu=$dbh->do("UPDATE t_opn_audit set opn_adj = '$adjust' WHERE RECID=$idadj");      
     
     }  
     if ($up_menu==0) {
         style_module::use_chkerror($dbh);
          return "canceled";         
     } else {
          return 'Updated.';
     }          
   
}

sub update_audit_fc1 {
   ($idadj,$adjust) = @_;
   
   if ($idadj) {
     
       $up_menu=$dbh->do("UPDATE t_opn_audit set fc_adj = '$adjust' WHERE RECID=$idadj");      
     
     }  
     if ($up_menu==0) {
         style_module::use_chkerror($dbh);
          return "canceled";         
     } else {
          return 'Updated.';
     }          
   
}

sub update_audit_fc {
   ($cab,$totalfinal,$tgltotal,$jenis) = @_;
      
   if ($totalfinal) {
	   
	   if ($jenis eq 'Dinnerware') {
	   
	   $insert_fc=$dbs->do("INSERT INTO t_insentif_str (store_id,ass_jenis,ass_tanggal,ass_nilai,ass_pass)
	   values ('$cab','W','$tgltotal','$totalfinal','Y')");      
     if ($insert_fc==0) {
            style_module::use_chkerror($dbs);
            return 'Cancel Proses.';            
        } else {
            $dbs->commit;
            return 'Insert Berhasil';                               
        }        
      }  
	else { 
	$insert_fc=$dbs->do("INSERT INTO t_insentif_str (store_id,ass_jenis,ass_tanggal,ass_nilai,ass_pass)
	   values ('$cab','D','$tgltotal','$totalfinal','Y')");      
     if ($insert_fc==0) {
            style_module::use_chkerror($dbs);
            return 'Cancel Proses.';            
        } else {
            $dbs->commit;
            return 'Insert Berhasil';                               
        }        
      }  
	
      
   }
   
}




1;
