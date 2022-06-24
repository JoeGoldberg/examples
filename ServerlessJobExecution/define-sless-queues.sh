#!/bin/bash

ctm run event::add smprod jog-sless-hostgroup-folder-slessaws:jog-sless-aws NoDate
ctm run event::add smprod jog-sless-hostgroup-name:slessaws NoDate

ctm run event::add smprod jog-sless-hostgroup-folder-slessaz:jog-sless-az NoDate
ctm run event::add smprod jog-sless-hostgroup-name:slessaz NoDate

ctm run event::add smprod jog-sless-hostgroup-folder-slessgcp:jog-sless-gcp NoDate
ctm run event::add smprod jog-sless-hostgroup-name:slessgcp NoDate