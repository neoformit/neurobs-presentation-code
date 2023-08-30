##########################################################
#																			#
# static Sneaky Skateboard Game IIGI training				#
#																			#
# MAIN SCENARIO														#
# ___________________________________________________ 	#
#																			#
# January 2018; adjusted 03/2020									#
# Adjustments by Tim van Timmeren & Irene van de Vijver 	#
#																			#
# Implementation vs goal intentions in training phase		#
# fMRI experiment												      # 
# ___________________________________________________ 	#
#																			#
# Irene van de Vijver												#
# University of Amsterdam											#
# irenevandevijver@gmail.com										#
#																			#
##########################################################


# SDL Header
active_buttons 			 = 5;
button_codes 				 = 1,2,3,4,5;		# 1=spacebar, 2=left mouse button, 3=backspace, 4=right alt, 5=right control 
# In scanner: 1=b (blue: most left button buttonbox), 2=left mouse button, 3=backspace, 4=y (yellow: left middle button buttonbox), 5=g (green: right middle button buttonbox)													

# FMRI			
#scenario_type 		= fMRI_emulation; #fMRI
#scan_period = 2000;
#scenario_type 		= fMRI;
#pulses_per_scan 	= 1;
#pulse_code 			= 255;


default_all_responses 	 = true;				
default_background_color = 0,0,0;	 		# black background
default_text_color 		 = 250,250,250;	# white text
default_font_size			 = 24;
default_font				 = "arial";

response_matching 		 = simple_matching;

#######################################################
#######################################################
# SDL body
begin;

#######################################################
# DEFINE PICTURE PARTS AND PICTURES

TEMPLATE "sSSG_setup_pictures.tem";

#######################################################
# DEFINE TRIALS


trial {														# Instruction screens
	trial_type          = first_response;
	trial_duration      = forever;
	
	stimulus_event {						
		picture            intro_pic;
		response_active  = true;
		stimulus_time_in = 500;
		code             = "intro";
	}introEvent;		
}introTrial;

trial {														# Start block
	trial_type          = fixed; #first_response
	trial_duration      = 3000; #forever
	
	stimulus_event {						
		picture            block_pic;
		response_active  = true;
		stimulus_time_in = 2000;
		code             = "block";
		port_code		  = 10;
	}blockEvent;		
}blockTrial;

trial {														# Present valuable outcomes
	trial_type          = fixed;
	trial_duration      = 1000;
	
	stimulus_event {						
		picture            outcomes_pic;
		response_active  = false;
		code             = "outcomes";
		port_code		  = 11;
	}outcomesEvent;		
}outcomesTrial;

trial {														# Select which outcomes to collect (fruitpicker)
stimulus_event {						
		picture            selection_pic;
		response_active  = true;
		code             = "selection";
	}selectionEvent;		
}selectionTrial;

trial {														# Present implementation/goal intention
	trial_type          = first_response;
	trial_duration      = 2000;
	
	stimulus_event {						
		picture            intention_pic;
		response_active  = true;
		code             = "intention";
		port_code		  = 12;
	}intentionEvent;		
}intentionTrial;

trial {														# Start trials
	trial_type          = fixed;
	trial_duration      = 1500;
	
	stimulus_event {						
		picture            start_pic;
		response_active  = false;
		code             = "start";
		port_code		  = 13;
	}startEvent;		
}startTrial;

trial {														# ITI during training/test
	trial_type          = fixed;
	trial_duration      = 1000;
	
	stimulus_event {						
		picture            ITI_pic;
		response_active  = false;
		code             = "ITI";
		port_code		  = 40;
	}ITIEvent;		
}ITITrial;

trial {														# Trial during training/test
	trial_type			  = fixed;
	trial_duration		  = 500;
	
	stimulus_event {						
		picture            trial_pic;
		response_active  = true;
		code             = "trial";
		port_code		  = 50;
	}runEvent;		
}runTrial;

trial {														# Present score
	trial_type     	  = fixed;
	trial_duration 	  = 4000;
	
	stimulus_event {						
		picture            score_pic;
		response_active  = false;
		code             = "score_trial";
		port_code		  = 14;
	}scoreEvent;		
}scoreTrial;

trial {														# Break
	trial_type          = first_response;
	trial_duration      = 1000;
	
	stimulus_event {						
		picture            break_pic;
		code             = "break";
		port_code		  = 15;
	}breakEvent;		
}breakTrial;

trial {														# Select outcome for each stimulus (SO test)
	stimulus_event {						
		picture            SO_pic;
		response_active  = true;
		code             = "SOtest";
	}SOEvent;		
}SOTrial;

trial {														# Blank screen
	stimulus_event {						
		picture            blank_pic;
		response_active  = false;
		code             = "blank";
	}blankEvent;		
}blankTrial;

trial {														# Select automaticity for each stimulus (SRBAI)
	stimulus_event {						
		picture            SRBAI_pic;
		response_active  = true;
		code             = "SRBAI";
	}SRBAIEvent;		
}SRBAITrial;

#################################################################	
#################################################################	
begin_pcl;

#######################################################
# DEFINE GENERAL VARIABLES
#
# These variables cannot be defined locally because
# they appear in multiple subscripts.

int demoORreal;		# 1 = demo,  0 = real
int trainORtest;		# 1 = train, 2 = test
int iiORgi;				# 1 = ii,    2 = gi
int no_val_screen;
int mri;
int start_intention; # 1== start ii, 2=start gi
int skateboarder;
int randnr;
int test_run;

string tmp_fn;
bool fe0;
output_file out_info;
output_file out_stimout;
output_file out_testval;
output_file out_show;
output_file out_check;
output_file out_int;
output_file out_train;
output_file out_test;
output_file out_so;
output_file out_srbai;
output_file out_triggers;
input_file in_stimout;
input_file in_testval;

int add_intentions;
int runtrials;
int no_outcome_screen;

int start_screen;
int end_screen;

array <int> loc_out[4]={1,2,3,4};
int nr_stim;
int nr_rep;

int blocktrials;
array <int> trial_order[1];
array <int> correct[2];		

int start_block;
int end_block;
int set_nr;
int bl;
int s;

int start_resp_nr;
int get_resp_nr;

int resp;
int curr_resp;
int resp1;
int resp2;

int curr_stim;
int curr_outcome;
int RT;
int RT_sce;
int resp_corr;
int fb_stay;
int late;

int start_time;
int curr_time;
int resp_time1;
int resp_time2;

int new_pic_part;
int new_pic_part_x;

int press_corr;
int inhib_corr;
int press_late;

int currpoints;
int blockpoints;
int totalpoints;

int screen_width	= display_device.width();
int screen_height	= display_device.height();

mouse mouse1 = response_manager.get_mouse(1);

#######################################################

include "sSSG_main_pcl.pcl";
