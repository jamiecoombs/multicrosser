import ActionCable from 'actioncable';
import MoveBuffer from 'move_buffer';

const createSubscription = function createSubscription(crossword, room, onReceiveMove, onReplayMove, onInitialState) {
  const cable = ActionCable.createConsumer(process.env.WEBSOCKET_URL);
  const moveBuffer = new MoveBuffer(room);

  return cable.subscriptions.create(
    { channel: 'MovesChannel', crossword, room },
    {
      received: function received(data) {
        console.log('received');
        if (data.initialState) {
          console.log('initialState');
          console.log(data.initialState);
          onInitialState(data.initialState);
        } else {
          console.log('move data');
          console.log(data);
          onReceiveMove(data);
        }
      },
      move: function move(data) {
        console.log('move');
        console.log(data);
        let success = false;
        try {
          success = this.perform('move', data);
        } catch (e) {
          // catch error
        } finally {
          if (!success) {
            moveBuffer.queue(data);
          }
        }
      },
      connected: function connected() {
        console.log('connected');
        moveBuffer.deqeueAll().forEach((move) => {
          onReplayMove(move);
        });
      },
    },
  );
};

export { createSubscription };
