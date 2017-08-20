#!/bin/bash

. $SCRIPT_SRC/lib/config.sh

declare -g -A WAREHOUSE_RESOURCES
declare -g -A TRANSPORT_RESOURCES

for file in $(ls $SCRIPT_SRC/config/resources/); do
	parse_file "RESOURCE" "$SCRIPT_SRC/config/resources/$file"
	
	echo "^Resource${RESOURCE['ID']}Carrier:"
	echo "	AmmoPool@Resource${RESOURCE['ID']}:"
	echo "		Name: Resource${RESOURCE['ID']}"
	echo "		PipType: ${RESOURCE['COLOR']}"
	echo "		PipTypeEmpty: AmmoEmpty"
	echo "		ShowAsTextPip: True"
	echo "		InitialAmmo: 1000000000"
	echo ""

	echo "^Resource${RESOURCE['ID']}Production:"
	echo "	Inherits@Resource${RESOURCE['ID']}Carrier: ^Resource${RESOURCE['ID']}Carrier"
	echo "	AmmoPool@Resource${RESOURCE['ID']}:"
	echo "		Ammo: ${RESOURCE['PRODUCTION_AMOUNT']}"
	echo "		ReloadCount: ${RESOURCE['PRODUCTION_AMOUNT']}"
	echo "		SelfReloads: True"
	echo "		SelfReloadDelay: ${RESOURCE['PRODUCTION_DELAY']}"
	echo "		PipCount: $((${RESOURCE['PRODUCTION_AMOUNT']} / ${RESOURCE['UNITS_PER_PIP']}))"
	echo "	AutoTarget:"
	echo "		AllowMovement: False"
	echo "	AutoTargetPriority@Resource${RESOURCE['ID']}Warehouse:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Warehouse"
	echo "		Priority: 1"
	echo "	Armament@Resource${RESOURCE['ID']}Production:"
	echo "		Weapon: Resource${RESOURCE['ID']}Production"
	echo "		TargetStances: Ally, Neutral"
	echo ""

	echo "^Resource${RESOURCE['ID']}Warehouse:"
	echo "	Inherits@Resource${RESOURCE['ID']}Carrier: ^Resource${RESOURCE['ID']}Carrier"
	echo "	AmmoPool@Resource${RESOURCE['ID']}:"
	echo "		Ammo: ${RESOURCE['WAREHOUSE_CAPACITY']}"
	echo "		PipCount: $((${RESOURCE['WAREHOUSE_CAPACITY']} / ${RESOURCE['UNITS_PER_PIP']}))"
	echo "	Targetable@Resource${RESOURCE['ID']}Warehouse:"
	echo "		TargetTypes: Resource${RESOURCE['ID']}Warehouse"
	echo "	AutoTarget:"
	echo "		AllowMovement: False"
	echo "	AutoTargetPriority@Resource${RESOURCE['ID']}Consumer:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Consumer"
	echo "		Priority: 1"
	echo "	AutoTargetPriority@Resource${RESOURCE['ID']}Transport:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Transport"
	echo "		Priority: 2"
	echo "	Armament@Resource${RESOURCE['ID']}Warehouse:"
	echo "		Weapon: Resource${RESOURCE['ID']}Warehouse"
	echo "		TargetStances: Ally, Neutral"
	echo ""

	echo "^Resource${RESOURCE['ID']}Transport:"
	echo "	Inherits@Resource${RESOURCE['ID']}Carrier: ^Resource${RESOURCE['ID']}Carrier"
	echo "	AmmoPool@Resource${RESOURCE['ID']}:"
	echo "		Ammo: ${RESOURCE['TRANSPORT_CAPACITY']}"
	echo "		PipCount: $((${RESOURCE['TRANSPORT_CAPACITY']} / ${RESOURCE['UNITS_PER_PIP']}))"
	echo "	Targetable@Resource${RESOURCE['ID']}Transport:"
	echo "		TargetTypes: Resource${RESOURCE['ID']}Transport"
	echo "	AutoTarget:"
	echo "		AllowMovement: True"
	echo "	AutoTargetPriority@Resource${RESOURCE['ID']}Consumer:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Consumer"
	echo "		Priority: 1"
	echo "	Armament@Resource${RESOURCE['ID']}Transport:"
	echo "		Weapon: Resource${RESOURCE['ID']}Transport"
	echo "		TargetStances: Ally"
	echo ""

	echo "^Resource${RESOURCE['ID']}Consumer:"
	echo "	Inherits@Resource${RESOURCE['ID']}Carrier: ^Resource${RESOURCE['ID']}Carrier"
	echo "	Targetable@Resource${RESOURCE['ID']}Consumer:"
	echo "		TargetTypes: Resource${RESOURCE['ID']}Consumer"
	echo ""
	echo ""
	
	WAREHOUSE_RESOURCES[${RESOURCE['WAREHOUSE_ID']}]="${WAREHOUSE_RESOURCES[${RESOURCE['WAREHOUSE_ID']}]} ${RESOURCE['ID']}"	
	TRANSPORT_RESOURCES[${RESOURCE['TRANSPORT_ID']}]="${TRANSPORT_RESOURCES[${RESOURCE['TRANSPORT_ID']}]} ${RESOURCE['ID']}"
done

for KEY in "${!WAREHOUSE_RESOURCES[@]}"
do
	echo "^ResourceWarehouse${KEY}:"
	for RESOURCE_ID in ${WAREHOUSE_RESOURCES[${KEY}]}; do
		echo "	Inherits@Resource${RESOURCE_ID}Warehouse: ^Resource${RESOURCE_ID}Warehouse"
	done
	echo ""
done
echo ""
for KEY in "${!TRANSPORT_RESOURCES[@]}"
do
	echo "^ResourceTransport${KEY}:"
	for RESOURCE_ID in ${TRANSPORT_RESOURCES[${KEY}]}; do
		echo "	Inherits@Resource${RESOURCE_ID}Transport: ^Resource${RESOURCE_ID}Transport"
	done
	echo ""
done
echo ""
