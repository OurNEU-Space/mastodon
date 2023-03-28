import React from 'react';
import { connect } from 'react-redux';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import { expandAccountTimeline } from 'flavours/glitch/actions/timelines';
import StatusList from '../../components/status_list';
import { List as ImmutableList } from 'immutable';

const mapStateToProps = (state, { accountId }) => {

  return {
    statusIds: state.getIn(['timelines', `account:${accountId}`, 'items'], ImmutableList()),
    isLoading: state.getIn(['timelines', `account:${accountId}`, 'isLoading']),
    hasMore: state.getIn(['timelines', `account:${accountId}`, 'hasMore']),
  };
};


export default @connect(mapStateToProps)
class NewsBotStatuses extends React.PureComponent {

  static propTypes = {
    accountId: PropTypes.string.isRequired,
    dispatch: PropTypes.func.isRequired,
    statusIds: ImmutablePropTypes.list,
    isLoading: PropTypes.bool,
    hasMore: PropTypes.bool,
    multiColumn: PropTypes.bool,
  };

  componentDidMount () {
    this.props.dispatch(expandAccountTimeline(this.props.accountId));
  }

  handleLoadMore = maxId => {
    this.props.dispatch(expandAccountTimeline(this.props.accountId, { maxId }));
  };

  render () {
    const { statusIds, isLoading, hasMore, multiColumn } = this.props;

    return (
      <StatusList
        scrollKey='news_bot_timeline'
        statusIds={statusIds}
        isLoading={isLoading}
        hasMore={hasMore}
        onLoadMore={this.handleLoadMore}
        timelineId='news_bot'
        bindToDocument={!multiColumn}
      />
    );
  }

}
