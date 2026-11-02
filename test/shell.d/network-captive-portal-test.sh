#!/bin/bash

set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

run_node_test <<'JS'
const network = requireFromRoot('shell/plugins/panels/network/Model.js')
const states = { Unknown: 0, None: 1, Portal: 2, Limited: 3, Full: 4 }

for (const kind of ['wifi', 'ethernet']) {
  for (const [native, expected] of [
    ['Unknown', 'unknown'], ['None', 'none'], ['Portal', 'portal'],
    ['Limited', 'limited'], ['Full', 'full']
  ]) {
    assertEqual(network.connectivityState(kind, states[native], states, true), expected,
      `${kind} maps native ${native} connectivity without confusing an outage with a portal`)
  }
  assertEqual(network.connectivityState(kind, 99, states, true), 'unknown', `${kind} handles unknown connectivity`)
  for (const native of Object.values(states)) {
    assertEqual(network.connectivityState(kind, native, states, false), 'unknown', `${kind} ignores stale results with probing disabled (${native})`)
  }
}
for (const native of Object.values(states)) {
  assertEqual(network.connectivityState('disconnected', native, states, true), 'none', `disconnect clears stale connectivity (${native})`)
}
for (const state of ['portal', 'limited']) {
  assertEqual(network.connectionIcon('wifi', 80, state), '󰤩', `${state} uses a blocked Wi-Fi icon`)
  assertEqual(network.connectionIcon('ethernet', 80, state), '󰈂', `${state} uses a blocked Ethernet icon`)
  assertEqual(network.connectionIcon('disconnected', 80, state), '󰤮', `${state} does not override the disconnected icon`)
}
for (const state of ['full', 'unknown', 'none', undefined]) {
  for (const signal of [-1, 0, 20, 40, 60, 80, 100]) {
    assertEqual(network.connectionIcon('wifi', signal, state), network.wifiIconFor(signal), `${state} preserves Wi-Fi strength ${signal}`)
  }
  assertEqual(network.connectionIcon('ethernet', -1, state), '󰈀', `${state} preserves the Ethernet icon`)
}
JS
