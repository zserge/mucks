#!/bin/bash
#set -e

. assert.sh

TEST="yes" # to skip real execution of mucks
. mucks

# Test trim
assert "trim 'foo'" "foo"
assert "trim 'foo   '" "foo"
assert "trim 'foo	'" "foo"
assert_end "trim"

# TODO Test comments
# Test parse_header
parse_header 'foo: bar'
assert "echo $CONFIG_foo" "bar"

parse_header 'foo: bar'
parse_header 'hello:   a b c  '
parse_header 'world:   a : b : c  '
assert "echo $CONFIG_foo" "bar"
assert "echo $CONFIG_hello" "a b c"
assert "echo $CONFIG_world" "a : b : c"

assert_end "parse_header"

# Stubs for mux_ functions
mux_new_window() {
	true
}
mux_hsplit() {
	true
}
mux_vsplit() {
	true
}
mux_layout() {
	true
}
mux_sleep() {
	true
}
mux_send() {
	true
}
mux_finalize() {
	true
}

# Test readcfg
parse_config 3<< EOF
name: Test project
dir: ~/src

[Window 1]
external cmd 1
- split 
external cmd 2

[Window 2]
external cmd 3
EOF
assert "echo $CONFIG_name" "Test project"
assert "echo $CONFIG_dir" "$HOME/src" # '~' turns to $HOME value

assert_end "parse_config"


