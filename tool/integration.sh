#!/bin/bash

set -e

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

flutter drive --target=test_driver/video_player.dart
echo 'test_driver/video_player.dart OK'

flutter drive --target=test_driver/web_view.dart
echo 'test_driver/web_view.dart OK'
