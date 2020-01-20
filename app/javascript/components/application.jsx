import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';

import logger from 'logger';
import actions from 'actions';

import Passage from 'components/passage';
import Log from 'components/log';
import SaveGames from 'components/save_games';

const Application = ({debug}) => {
  const [loading, setLoading] = useState(true);
  const [activeGame, setActiveGame] = useState();
  const [messages, setMessages] = useState([]);

  const fetchPassage = () =>
    actions.fetchActiveGame().then(game => {
      setActiveGame(game);
      setLoading(false);
    });

  useEffect(() => {
    fetchPassage();
  }, []);

  useEffect(() => {
    actions.fetchMessages().then(messages => {
      logger.debug('Messages successfully fetched', messages);
      setMessages(messages);

      actions.subscribeForMessages(message => {
        logger.debug('New message received', message);
        setMessages([message, ...messages]);
        fetchPassage();
      });
    });
  }, []);

  const choosePassage = ({ref}) => {
    const data = new FormData();
    data.append('save_game[passage_ref]', ref);

    fetch(`/save_games/${activeGame.id}`, {method: 'PUT', body: data}).then(
      () => fetchPassage(),
    );
  };

  if (loading) {
    return <p>Loading...</p>;
  }

  if (!activeGame) {
    return <p>No active game found. Start one using Alexa and reload.</p>;
  }

  return (
    <div className="app">
      {debug && (
        <aside className="messages">
          <h3>Debug Logging Active...</h3>
          <hr />
          {messages.map(msg => (
            <Log key={msg.id} {...msg} />
          ))}
        </aside>
      )}
      <div className="content">
        <Passage active={activeGame} onUpdate={choosePassage} />
      </div>
      <SaveGames onChange={fetchPassage} />
    </div>
  );
};

Application.propTypes = {debug: PropTypes.bool.isRequired};
Application.defaultProps = {debug: true};

export default Application;
