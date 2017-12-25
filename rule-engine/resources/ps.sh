#!/usr/bin/env bash

pattern=${1}

ps aux | grep ${pattern}
