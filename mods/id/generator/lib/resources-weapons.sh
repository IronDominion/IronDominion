#!/bin/bash

. $SCRIPT_SRC/lib/config.sh

for file in $(ls $SCRIPT_SRC/config/resources/); do
	parse_file "RESOURCE" "$SCRIPT_SRC/config/resources/$file"
	
	echo "^Resource${RESOURCE['ID']}:"
	echo "	ReloadDelay: 0"
	echo "	BurstDelay: 0"
	echo "	TargetActorCenter: True"
	echo "	Projectile: InstantHit"
	echo "	Warhead@Resource${RESOURCE['ID']}: TransferAmmo"
	echo "		AmmoPoolName: Resource${RESOURCE['ID']}"
	echo "		ReturnAmmo: True"
	echo "		DebugOverlayColor: 00FF00"
	echo ""
	echo "Resource${RESOURCE['ID']}Production:"
	echo "	Inherits@Resource${RESOURCE['ID']}: ^Resource${RESOURCE['ID']}"
	echo "	Range: 20c0"
	echo "	ValidTargets: Resource${RESOURCE['ID']}Warehouse"
	echo "	Warhead@Resource${RESOURCE['ID']}:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Warehouse"
	echo "		Amount: $((${RESOURCE['PRODUCTION_AMOUNT']} / ${RESOURCE['PRODUCTION_DELAY']}))"
	echo ""
	echo "Resource${RESOURCE['ID']}Warehouse:"
	echo "	Inherits@Resource${RESOURCE['ID']}: ^Resource${RESOURCE['ID']}"
	echo "	Range: 1c0"
	echo "	ValidTargets: Resource${RESOURCE['ID']}Transport, Resource${RESOURCE['ID']}Consumer"
	echo "	Warhead@Resource${RESOURCE['ID']}:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Transport, Resource${RESOURCE['ID']}Consumer"
	echo "		Amount: ${RESOURCE['WAREHOUSE_TRANSFER']}"
	echo ""
	echo "Resource${RESOURCE['ID']}Transport:"
	echo "	Inherits@Resource${RESOURCE['ID']}: ^Resource${RESOURCE['ID']}"
	echo "	Range: 3c0"
	echo "	ValidTargets: Resource${RESOURCE['ID']}Transport, Resource${RESOURCE['ID']}Consumer"
	echo "	Warhead@Resource${RESOURCE['ID']}:"
	echo "		ValidTargets: Resource${RESOURCE['ID']}Transport, Resource${RESOURCE['ID']}Consumer"
	echo "		Amount: ${RESOURCE['TRANSPORT_TRANSFER']}"
	echo ""
	echo ""
done
