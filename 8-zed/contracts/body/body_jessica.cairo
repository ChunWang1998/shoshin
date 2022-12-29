%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from contracts.constants.constants import (
    BodyState, ns_stimulus
)
from contracts.constants.jessica import (
    ns_jessica_action, ns_jessica_body_state, ns_jessica_body_state_duration, ns_jessica_body_state_qualifiers
)

//
// Jessica's Body State Diagram
//
func _body_jessica {range_check_ptr}(
        body_state: BodyState, stimulus: felt, intent: felt
    ) -> (
        body_state_nxt: BodyState
) {

    // Unpack
    let state = body_state.state
    let counter = body_state.counter
    let integrity = body_state.integrity
    let stamina = body_state.stamina
    let dir = body_state.dir

    //
    // Idle
    //
    if (state == ns_jessica_body_state.IDLE) {
        // interrupt by stimulus - priority > agent action
        if (stimulus == ns_stimulus.HURT) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) {
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // interrupt by agent action; locomotive action has lowest priority
        if (intent == ns_jessica_action.SLASH) {
            return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) {
            return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) {
            return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.BLOCK) {
            return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.DASH_FORWARD) {
            return BodyState(ns_jessica_body_state.DASH_FORWARD, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.DASH_BACKWARD) {
            return BodyState(ns_jessica_body_state.DASH_BACKWARD, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.MOVE_FORWARD) {
            return BodyState(ns_jessica_body_state.MOVE_FORWARD, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.MOVE_BACKWARD) {
            return BodyState(ns_jessica_body_state.MOVE_BACKWARD, 0, integrity, stamina, dir);
        }

        // otherwise stay in IDLE but increment counter modulo duration
        if (counter == ns_jessica_body_state_duration.IDLE) {
            return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
        } else {
            return BodyState(ns_jessica_body_state.IDLE, counter + 1, integrity, stamina, dir);
        }
    }

    //
    // Slash
    //
    if (state == ns_jessica_body_state.SLASH) {

        if ( ns_jessica_body_state_qualifiers.is_in_slash_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // active, but clashing => go to HURT (eventually can have clash animation; now reusing hurt animation)
        if (stimulus == ns_stimulus.CLASH) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }

        // if intent remains SLASH
        if (intent == ns_jessica_action.SLASH) {
            if (counter == ns_jessica_body_state_duration.SLASH) { // reset counter
                return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.SLASH, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }


    //
    // Upswing
    //
    if (state == ns_object_state.UPSWING) {
        if ( ns_jessica_body_state_qualifiers.is_in_upswing_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // active, but clashing => go to HURT (eventually can have clash animation; now reusing hurt animation)
        if (stimulus == ns_stimulus.CLASH) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }

        // if intent remains UPSWING
        if (intent == ns_jessica_action.UPSWING) {
            if (counter == ns_jessica_body_state_duration.UPSWING) { // reset counter
                return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.UPSWING, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Sidecut
    //
    if (state == ns_object_state.SIDECUT) {
        if ( ns_jessica_body_state_qualifiers.is_in_sidecut_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // active, but clashing => go to HURT (eventually can have clash animation; now reusing hurt animation)
        if (stimulus == ns_stimulus.CLASH) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }

        // if intent remains SIDECUT
        if (intent == ns_jessica_action.SIDECUT) {
            if (counter == ns_jessica_body_state_duration.SIDECUT) { // reset counter
                return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.SIDECUT, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Block
    //
    if (state == ns_jessica_body_state.BLOCK) {

        if ( ns_jessica_body_state_qualifiers.is_in_block_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // if intent remains BLOCK
        if (intent == ns_jessica_action.BLOCK) {
            if (counter == ns_jessica_body_state_duration.BLOCK) { // reset counter
                return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.BLOCK, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Hurt
    //
    if (state == ns_jessica_body_state.HURT) {

        // check for interruption
        if (stimulus == ns_stimulus.HURT) { // hurt again while in hurt => stay in hurt but reset counter
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) { // knocked while in hurt => worsen into knocked
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // if counter is full => return to IDLE
        if (counter == ns_jessica_body_state_duration.HURT) {
            return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
        }

        // else stay in HURT and increment counter
        return BodyState(ns_jessica_body_state.HURT, counter + 1, integrity, stamina, dir);
    }

    //
    // Knocked
    //
    if (state == ns_jessica_body_state.KNOCKED) {

        // check for interruption
        if (stimulus == ns_stimulus.HURT) { // hurt while in knocked => stay in knocked and reset counter
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) { // hurt while in knocked => stay in knocked and reset counter
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // if counter is full => return to Idle
        if (counter == ns_jessica_body_state_duration.KNOCKED) {
            return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
        }

        // else stay in KNOCKED and increment counter
        return BodyState(ns_jessica_body_state.KNOCKED, counter + 1, integrity, stamina, dir);
    }

    //
    // Move forward
    //
    if (state == ns_jessica_body_state.MOVE_FORWARD) {

        // interruptible by stimulus
        if (stimulus == ns_stimulus.HURT) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) {
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // interruptible by agent intent (locomotive action has lowest priority)
        if (intent == ns_jessica_action.SLASH) {
            return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) {
            return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) {
            return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.BLOCK) {
            return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
        }

        // continue moving forward
        if (intent == ns_jessica_action.MOVE_FORWARD) {
            if (counter == ns_jessica_body_state_duration.MOVE_FORWARD) {
                return BodyState(ns_jessica_body_state.MOVE_FORWARD, 0, integrity, stamina, dir);
            } else {
                return BodyState(ns_jessica_body_state.MOVE_FORWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // able to reverse direction immediately
        if (intent == ns_jessica_action.MOVE_BACKWARD) {
            return BodyState(ns_jessica_body_state.MOVE_BACKWARD, 0, integrity, stamina, dir);
        }

        // otherwise return to idle
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Move backward
    //
    if (state == ns_jessica_body_state.MOVE_BACKWARD) {

        // interruptible by stimulus
        if (stimulus == ns_stimulus.HURT) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) {
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // interruptible by agent intent (locomotive action has lowest priority)
        if (intent == ns_jessica_action.SLASH) {
            return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) {
            return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) {
            return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.BLOCK) {
            return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
        }

        // continue moving forward
        if (intent == ns_jessica_action.MOVE_BACKWARD) {
            if (counter == ns_jessica_body_state_duration.MOVE_BACKWARD) {
                return BodyState(ns_jessica_body_state.MOVE_BACKWARD, 0, integrity, stamina, dir);
            } else {
                return BodyState(ns_jessica_body_state.MOVE_BACKWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // able to reverse direction immediately
        if (intent == ns_jessica_action.MOVE_FORWARD) {
            return BodyState(ns_jessica_body_state.MOVE_FORWARD, 0, integrity, stamina, dir);
        }

        // otherwise return to idle
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Dash forward
    // note: DASH is currently uninterruptible by stimulus, meaning it is perfect defense;
    //       plus it can be canceled directly into the active frame of various attacks, making it insanely powerful;
    //       need to add cost such as stamina consumption
    //
    if (state == ns_jessica_body_state.DASH_FORWARD) {

        // interruptible by offensive intent
        if (intent == ns_jessica_action.SLASH) { // go straight to SLASH's active frame
            return BodyState(ns_jessica_body_state.SLASH, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) { // go straight to UPSWING's active frame
            return BodyState(ns_jessica_body_state.UPSWING, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) { // go straight to SIDECUT's active frame
            return BodyState(ns_jessica_body_state.SIDECUT, 2, integrity, stamina, dir);
        }

        // note: not able to reverse to the opposite dash immediately

        // if intent remains DASH_FORWARD
        if (intent == ns_jessica_action.DASH_FORWARD) {
            if (counter == ns_jessica_body_state_duration.DASH_FORWARD) { // reset counter
                return BodyState(ns_jessica_body_state.DASH_FORWARD, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.DASH_FORWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Dash backward
    //
    if (state == ns_jessica_body_state.DASH_BACKWARD) {

        // interruptible by offensive intent
        if (intent == ns_jessica_action.SLASH) { // go straight to SLASH's active frame
            return BodyState(ns_jessica_body_state.SLASH, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) { // go straight to UPSWING's active frame
            return BodyState(ns_jessica_body_state.UPSWING, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) { // go straight to SIDECUT's active frame
            return BodyState(ns_jessica_body_state.SIDECUT, 2, integrity, stamina, dir);
        }

        // note: not able to reverse to the opposite dash immediately

        // if intent remains DASH_BACKWARD
        if (intent == ns_jessica_action.DASH_BACKWARD) {
            if (counter == ns_jessica_body_state_duration.DASH_BACKWARD) { // reset counter
                return BodyState(ns_jessica_body_state.DASH_BACKWARD, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.DASH_BACKWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    with_attr error_message("Input body state is not recognized.") {
        assert 0 = 1;
    }
    return BodyState(0,0,0,0,0);
}



//
// Antoc's Body State Diagram
//
func _body_1 {range_check_ptr}(
        body_state: BodyState, stimulus: felt, intent: felt
    ) -> (
        body_state_nxt: BodyState
) {

    // Unpack
    let state = body_state.state
    let counter = body_state.counter
    let integrity = body_state.integrity
    let stamina = body_state.stamina
    let dir = body_state.dir

    //
    // Idle
    //
    if (state == ns_antoc_body_state.IDLE) {
        // interrupt by stimulus - priority > agent action
        if (stimulus == ns_stimulus.HURT) {
            return BodyState(ns_antoc_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) {
            return BodyState(ns_antoc_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // interrupt by agent action; locomotive action has lowest priority
        if (intent == ns_antoc_action.HORI) {
            return BodyState(ns_antoc_body_state.HORI, 0, integrity, stamina, dir);
        }
        if (intent == ns_antoc_action.VERT) {
            return BodyState(ns_antoc_body_state.VERT, 0, integrity, stamina, dir);
        }
        if (intent == ns_antoc_action.BLOCK) {
            return BodyState(ns_antoc_body_state.BLOCK, 0, integrity, stamina, dir);
        }
        if (intent == ns_antoc_action.DASH_FORWARD) {
            return BodyState(ns_antoc_body_state.DASH_FORWARD, 0, integrity, stamina, dir);
        }
        if (intent == ns_antoc_action.DASH_BACKWARD) {
            return BodyState(ns_antoc_body_state.DASH_BACKWARD, 0, integrity, stamina, dir);
        }
        if (intent == ns_antoc_action.MOVE_FORWARD) {
            return BodyState(ns_antoc_body_state.MOVE_FORWARD, 0, integrity, stamina, dir);
        }
        if (intent == ns_antoc_action.MOVE_BACKWARD) {
            return BodyState(ns_antoc_body_state.MOVE_BACKWARD, 0, integrity, stamina, dir);
        }

        // otherwise stay in IDLE but increment counter modulo duration
        if (counter == ns_antoc_body_state_duration.IDLE) {
            return BodyState(ns_antoc_body_state.IDLE, 0, integrity, stamina, dir);
        } else {
            return BodyState(ns_antoc_body_state.IDLE, counter + 1, integrity, stamina, dir);
        }
    }

    //
    // HORI
    //
    if (state == ns_antoc_body_state.HORI) {

        if ( ns_antoc_body_state_qualifiers.is_in_hori_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_antoc_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_antoc_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // active, but clashing => go to HURT (eventually can have clash animation; now reusing hurt animation)
        if (stimulus == ns_stimulus.CLASH) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }

        // if intent remains SLASH
        if (intent == ns_jessica_action.SLASH) {
            if (counter == ns_jessica_body_state_duration.SLASH) { // reset counter
                return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.SLASH, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }


    //
    // Upswing
    //
    if (state == ns_object_state.UPSWING) {
        if ( ns_jessica_body_state_qualifiers.is_in_upswing_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // active, but clashing => go to HURT (eventually can have clash animation; now reusing hurt animation)
        if (stimulus == ns_stimulus.CLASH) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }

        // if intent remains UPSWING
        if (intent == ns_jessica_action.UPSWING) {
            if (counter == ns_jessica_body_state_duration.UPSWING) { // reset counter
                return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.UPSWING, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Sidecut
    //
    if (state == ns_object_state.SIDECUT) {
        if ( ns_jessica_body_state_qualifiers.is_in_sidecut_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // active, but clashing => go to HURT (eventually can have clash animation; now reusing hurt animation)
        if (stimulus == ns_stimulus.CLASH) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }

        // if intent remains SIDECUT
        if (intent == ns_jessica_action.SIDECUT) {
            if (counter == ns_jessica_body_state_duration.SIDECUT) { // reset counter
                return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.SIDECUT, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Block
    //
    if (state == ns_jessica_body_state.BLOCK) {

        if ( ns_jessica_body_state_qualifiers.is_in_block_active(state, counter) == 0 ) { // interruptable by being attacked
            if (stimulus == ns_stimulus.HURT) {
                return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
            }
            if (stimulus == ns_stimulus.KNOCKED) {
                return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
            }
        }

        // if intent remains BLOCK
        if (intent == ns_jessica_action.BLOCK) {
            if (counter == ns_jessica_body_state_duration.BLOCK) { // reset counter
                return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.BLOCK, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Hurt
    //
    if (state == ns_jessica_body_state.HURT) {

        // check for interruption
        if (stimulus == ns_stimulus.HURT) { // hurt again while in hurt => stay in hurt but reset counter
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) { // knocked while in hurt => worsen into knocked
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // if counter is full => return to IDLE
        if (counter == ns_jessica_body_state_duration.HURT) {
            return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
        }

        // else stay in HURT and increment counter
        return BodyState(ns_jessica_body_state.HURT, counter + 1, integrity, stamina, dir);
    }

    //
    // Knocked
    //
    if (state == ns_jessica_body_state.KNOCKED) {

        // check for interruption
        if (stimulus == ns_stimulus.HURT) { // hurt while in knocked => stay in knocked and reset counter
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) { // hurt while in knocked => stay in knocked and reset counter
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // if counter is full => return to Idle
        if (counter == ns_jessica_body_state_duration.KNOCKED) {
            return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
        }

        // else stay in KNOCKED and increment counter
        return BodyState(ns_jessica_body_state.KNOCKED, counter + 1, integrity, stamina, dir);
    }

    //
    // Move forward
    //
    if (state == ns_jessica_body_state.MOVE_FORWARD) {

        // interruptible by stimulus
        if (stimulus == ns_stimulus.HURT) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) {
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // interruptible by agent intent (locomotive action has lowest priority)
        if (intent == ns_jessica_action.SLASH) {
            return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) {
            return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) {
            return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.BLOCK) {
            return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
        }

        // continue moving forward
        if (intent == ns_jessica_action.MOVE_FORWARD) {
            if (counter == ns_jessica_body_state_duration.MOVE_FORWARD) {
                return BodyState(ns_jessica_body_state.MOVE_FORWARD, 0, integrity, stamina, dir);
            } else {
                return BodyState(ns_jessica_body_state.MOVE_FORWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // able to reverse direction immediately
        if (intent == ns_jessica_action.MOVE_BACKWARD) {
            return BodyState(ns_jessica_body_state.MOVE_BACKWARD, 0, integrity, stamina, dir);
        }

        // otherwise return to idle
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Move backward
    //
    if (state == ns_jessica_body_state.MOVE_BACKWARD) {

        // interruptible by stimulus
        if (stimulus == ns_stimulus.HURT) {
            return BodyState(ns_jessica_body_state.HURT, 0, integrity, stamina, dir);
        }
        if (stimulus == ns_stimulus.KNOCKED) {
            return BodyState(ns_jessica_body_state.KNOCKED, 0, integrity, stamina, dir);
        }

        // interruptible by agent intent (locomotive action has lowest priority)
        if (intent == ns_jessica_action.SLASH) {
            return BodyState(ns_jessica_body_state.SLASH, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) {
            return BodyState(ns_jessica_body_state.UPSWING, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) {
            return BodyState(ns_jessica_body_state.SIDECUT, 0, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.BLOCK) {
            return BodyState(ns_jessica_body_state.BLOCK, 0, integrity, stamina, dir);
        }

        // continue moving forward
        if (intent == ns_jessica_action.MOVE_BACKWARD) {
            if (counter == ns_jessica_body_state_duration.MOVE_BACKWARD) {
                return BodyState(ns_jessica_body_state.MOVE_BACKWARD, 0, integrity, stamina, dir);
            } else {
                return BodyState(ns_jessica_body_state.MOVE_BACKWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // able to reverse direction immediately
        if (intent == ns_jessica_action.MOVE_FORWARD) {
            return BodyState(ns_jessica_body_state.MOVE_FORWARD, 0, integrity, stamina, dir);
        }

        // otherwise return to idle
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Dash forward
    // note: DASH is currently uninterruptible by stimulus, meaning it is perfect defense;
    //       plus it can be canceled directly into the active frame of various attacks, making it insanely powerful;
    //       need to add cost such as stamina consumption
    //
    if (state == ns_jessica_body_state.DASH_FORWARD) {

        // interruptible by offensive intent
        if (intent == ns_jessica_action.SLASH) { // go straight to SLASH's active frame
            return BodyState(ns_jessica_body_state.SLASH, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) { // go straight to UPSWING's active frame
            return BodyState(ns_jessica_body_state.UPSWING, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) { // go straight to SIDECUT's active frame
            return BodyState(ns_jessica_body_state.SIDECUT, 2, integrity, stamina, dir);
        }

        // note: not able to reverse to the opposite dash immediately

        // if intent remains DASH_FORWARD
        if (intent == ns_jessica_action.DASH_FORWARD) {
            if (counter == ns_jessica_body_state_duration.DASH_FORWARD) { // reset counter
                return BodyState(ns_jessica_body_state.DASH_FORWARD, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.DASH_FORWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    //
    // Dash backward
    //
    if (state == ns_jessica_body_state.DASH_BACKWARD) {

        // interruptible by offensive intent
        if (intent == ns_jessica_action.SLASH) { // go straight to SLASH's active frame
            return BodyState(ns_jessica_body_state.SLASH, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.UPSWING) { // go straight to UPSWING's active frame
            return BodyState(ns_jessica_body_state.UPSWING, 2, integrity, stamina, dir);
        }
        if (intent == ns_jessica_action.SIDECUT) { // go straight to SIDECUT's active frame
            return BodyState(ns_jessica_body_state.SIDECUT, 2, integrity, stamina, dir);
        }

        // note: not able to reverse to the opposite dash immediately

        // if intent remains DASH_BACKWARD
        if (intent == ns_jessica_action.DASH_BACKWARD) {
            if (counter == ns_jessica_body_state_duration.DASH_BACKWARD) { // reset counter
                return BodyState(ns_jessica_body_state.DASH_BACKWARD, 0, integrity, stamina, dir);
            }
            else { // increment counter
                return BodyState(ns_jessica_body_state.DASH_BACKWARD, counter + 1, integrity, stamina, dir);
            }
        }

        // otherwise return to IDLE
        return BodyState(ns_jessica_body_state.IDLE, 0, integrity, stamina, dir);
    }

    with_attr error_message("Input body state is not recognized.") {
        assert 0 = 1;
    }
    return BodyState(0,0,0,0,0);
}
