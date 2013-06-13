#!/bin/sh

# swap middle and right button
MICROSOFT_INTELLIEYE_MOUSE_ID=$(xinput list | grep "IntelliEye" | sed -r 's/.*id=([0-9]+).*/\1/')
xinput --set-button-map ${MICROSOFT_INTELLIEYE_MOUSE_ID} 1 3 2

# swap middle and right button
MICROSOFT_SIDEWINDER_X3_MOUSE_ID=$(xinput list | grep "SideWinder" | sed -r 's/.*id=([0-9]+).*/\1/')
xinput --set-button-map ${MICROSOFT_SIDEWINDER_X3_MOUSE_ID} 1 3 2


