#!/usr/bin/env bash

tf init ./topology/
tf validate ./topology/
tf plan -out out.tfplan ./topology/
tf apply out.tfplan