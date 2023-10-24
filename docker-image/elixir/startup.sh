#!/bin/bash

mix deps.get
mix local.hex --force -y
mix local.rebar --force -y

mix
