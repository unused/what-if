import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';

import logger from 'logger';
import actions from 'actions';

const SaveGames = ({selected, onChange}) => {
  const [games, setGames] = useState([]);

  const loadSaveGame = event => {
    fetch(`/save_games/${event.target.value}/load`).then(onChange);
  };

  useEffect(() => {
    actions.fetchSaveGames().then(setGames);
  }, []);

  return (
    <form className="form-row" className="save-games">
      <label htmlFor="save-games" className="label">Switch to Save Game</label>
      <select id="save-games" name="save-games" value={selected} onChange={loadSaveGame}>
        <option></option>
        {games.map(game => (
          <option key={game.id} value={game.id}>{game.story.title}</option>
        ))}
      </select>
    </form>
  );
};

SaveGames.propTypes = {
  onChange: PropTypes.func.isRequired,
  selected: PropTypes.string,
};

export default SaveGames;
