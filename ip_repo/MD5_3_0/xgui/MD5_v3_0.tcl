# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "IN_DATA_WIDTH"
  ipgui::add_param $IPINST -name "OUT_DATA_WIDTH"

}

proc update_PARAM_VALUE.IN_DATA_WIDTH { PARAM_VALUE.IN_DATA_WIDTH } {
	# Procedure called to update IN_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IN_DATA_WIDTH { PARAM_VALUE.IN_DATA_WIDTH } {
	# Procedure called to validate IN_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.OUT_DATA_WIDTH { PARAM_VALUE.OUT_DATA_WIDTH } {
	# Procedure called to update OUT_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUT_DATA_WIDTH { PARAM_VALUE.OUT_DATA_WIDTH } {
	# Procedure called to validate OUT_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.IN_DATA_WIDTH { MODELPARAM_VALUE.IN_DATA_WIDTH PARAM_VALUE.IN_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IN_DATA_WIDTH}] ${MODELPARAM_VALUE.IN_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.OUT_DATA_WIDTH { MODELPARAM_VALUE.OUT_DATA_WIDTH PARAM_VALUE.OUT_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUT_DATA_WIDTH}] ${MODELPARAM_VALUE.OUT_DATA_WIDTH}
}

