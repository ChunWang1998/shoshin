%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le

namespace ns_jessica_dynamics {

    const MAX_VEL_MOVE_FP = 120 * SCALE_FP;
    const MIN_VEL_MOVE_FP = (-120) * SCALE_FP;

    const MAX_VEL_DASH_FP = 600 * SCALE_FP;
    const MIN_VEL_DASH_FP = (-600) * SCALE_FP;

    const MOVE_ACC_FP = 300 * SCALE_FP;
    const DASH_ACC_FP = 3000 * SCALE_FP;

    const DEACC_FP = 10000 * SCALE_FP;
}

namespace ns_jessica_character_dimension {
    const BODY_HITBOX_W = 50;
    const BODY_HITBOX_H = 116;
    const BODY_KNOCKED_EARLY_HITBOX_W = 130;
    const BODY_KNOCKED_LATE_HITBOX_W = 150;
    const BODY_KNOCKED_EARLY_HITBOX_H = 125;
    const BODY_KNOCKED_LATE_HITBOX_H = 50;
    const SLASH_HITBOX_W = 90;
    const SLASH_HITBOX_H = 90;
    const SLASH_HITBOX_Y = BODY_HITBOX_H / 2;

    const BODY_KNOCKED_ADJUST_W = BODY_KNOCKED_LATE_HITBOX_W - BODY_HITBOX_W;
}

namespace ns_jessica_action {
    const NULL = 0;

    const SLASH = 1;
    const UPSWING = 2;
    const SIDECUT = 3;
    const BLOCK = 4;

    const MOVE_FORWARD  = 5;
    const MOVE_BACKWARD = 6;
    const DASH_FORWARD  = 7;
    const DASH_BACKWARD = 8;

    const COMBO = 10;
}

namespace ns_jessica_body_state_duration {
    const IDLE = 5;
    const SLASH = 5;
    const UPSWING = 5;
    const SIDECUT = 5;
    const BLOCK = 3;
    const HURT = 4;
    const KNOCKED = 11;
    const MOVE_FORWARD = 8;
    const MOVE_BACKWARD = 6;
    const DASH_FORWARD = 5;
    const DASH_BACKWARD = 5;
}

namespace ns_jessica_body_state {
    const IDLE = 0; // 5 frames
    const SLASH = 10; // 5 frames
    const UPSWING = 20;  // 5 frames
    const SIDECUT = 30;  // 5 frames
    const BLOCK = 40; // 3 frames
    const HURT = 50; // 4 frames
    const KNOCKED = 60; // 11 frames
    const MOVE_FORWARD = 80;  // 8 frames
    const MOVE_BACKWARD = 90;  // 6 frames
    const DASH_FORWARD = 100;  // 5 frames
    const DASH_BACKWARD = 110;  // 5 frames
}

namespace ns_jessica_body_state_qualifiers {

    func is_in_slash_active {range_check_ptr}(state: felt, counter: felt) -> (bool: felt) {
        if (state != ns_jessica_body_state.SLASH) {
            return (0,);
        }
        if (counter == 2) {
            return (1,);
        }
        return (0,);
    }

    func is_in_upswing_active {range_check_ptr}(state: felt, counter: felt) -> (bool: felt) {
        if (state != ns_jessica_body_state.UPSWING) {
            return (0,);
        }
        if (counter == 2) {
            return (1,);
        }
        return (0,);
    }

    func is_in_sidecut_active {range_check_ptr}(state: felt, counter: felt) -> (bool: felt) {
        if (state != ns_jessica_body_state.SIDECUT) {
            return (0,);
        }
        if (counter == 2) {
            return (1,);
        }
        return (0,);
    }

    func is_in_block_active {range_check_ptr}(state: felt, counter: felt) -> (bool: felt) {
        if (state != ns_jessica_body_state.BLOCK) {
            return (0,);
        }
        if (counter == 1) {
            return (1,);
        }
        return (0,);
    }

    func is_in_knocked_early {range_check_ptr}(state: felt, counter: felt) -> (bool: felt) {
        if (state != ns_jessica_body_state.KNOCKED) {
            return (0,);
        }

        // counter <= 4
        let bool_counter_le_4 = is_le (counter, 4);
        if (bool_counter_le_4 == 1) {
            return (1,);
        }
        return (0,);
    }

    func is_in_knocked_late {range_check_ptr}(state: felt, counter: felt) -> (bool: felt) {
        if (state != ns_jessica_body_state.KNOCKED) {
            return (0,);
        }

        // counter >= 5
        let bool_counter_ge_5 = is_le(5, counter);
        if (bool_counter_ge_5 == 1) {
            return (1,);
        }
        return (0,);
    }
}

