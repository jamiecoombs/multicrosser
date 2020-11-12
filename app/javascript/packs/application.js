import React from 'react';
import ReactDOM from 'react-dom';
import Crossword from 'jamie-react-crossword';
import { createSubscription } from 'subscription';

const crosswordElement = document.getElementsByClassName('js-crossword')[0];

const { crossword, crosswordIdentifier, room, author } = crosswordElement.dataset;
const crosswordData = JSON.parse(crossword);

const crosswordRef = React.createRef();
const onReceiveMove = (move) => { crosswordRef.current.setCellValue(move.x, move.y, move.value, move.author, false); };
const onReplayMove = (move) => {
  if (crosswordRef.current.getCellValue(move.x, move.y) === move.previousValue) {
    crosswordRef.current.setCellValue(move.x, move.y, move.value, move.author);
  }
};

const subscription = createSubscription(crosswordIdentifier, room, onReceiveMove, onReplayMove, (initialState) => {
  ReactDOM.render(<Crossword
    ref={crosswordRef}
    data={crosswordData}
    author={author}
    loadGrid={() => {}}
    saveGrid={() => {}}
    onMove={(move) => { subscription.move(move); }}
  />, crosswordElement);
  crosswordRef.current.updateGrid(initialState);
});
