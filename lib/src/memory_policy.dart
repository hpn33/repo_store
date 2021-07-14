// package com.dropbox.android.external.store4

// import java.util.concurrent.TimeUnit
// import kotlin.time.Duration
// import kotlin.time.ExperimentalTime
// import kotlin.time.toDuration

import 'package:flutter/cupertino.dart';

// typedef Weigher<Key, V> = int Function(Key key, V value);

abstract class Weigher<Key, V> {
  int weigh(Key key, V value);
}
// fun interface Weigher<in K : Any, in V : Any> {
//     /**
//      * Returns the weight of a cache entry. There is no unit for entry weights; rather they are simply
//      * relative to each other.
//      *
//      * @return the weight of the entry; must be non-negative
//      */
//     fun weigh(key: K, value: V): Int
// }

class OneWeigher extends Weigher {
  @override
  int weigh(key, value) => 1;
}
// internal object OneWeigher : Weigher<Any, Any> {
//     override fun weigh(key: Any, value: Any): Int = 1
// }

// /**
//  * MemoryPolicy holds all required info to create MemoryCache
//  *
//  *
//  * This class is used, in order to define the appropriate parameters for the Memory [com.dropbox.android.external.cache3.Cache]
//  * to be built.
//  *
//  *
//  * MemoryPolicy is used by a [Store]
//  * and defines the in-memory cache behavior.
//  */
// @ExperimentalTime
// class MemoryPolicy<in Key : Any, in Value : Any> internal constructor(
//     val expireAfterWrite: Duration,
//     val expireAfterAccess: Duration,
//     val maxSize: Long,
//     val maxWeight: Long,
//     val weigher: Weigher<Key, Value>
// ) {

//     val isDefaultWritePolicy: Boolean = expireAfterWrite == DEFAULT_DURATION_POLICY

//     val hasWritePolicy: Boolean = expireAfterWrite != DEFAULT_DURATION_POLICY

//     val hasAccessPolicy: Boolean = expireAfterAccess != DEFAULT_DURATION_POLICY

//     val hasMaxSize: Boolean = maxSize != DEFAULT_SIZE_POLICY

//     val hasMaxWeight: Boolean = maxWeight != DEFAULT_SIZE_POLICY

//     class MemoryPolicyBuilder<Key : Any, Value : Any> {
//         private var expireAfterWrite = DEFAULT_DURATION_POLICY
//         private var expireAfterAccess = DEFAULT_DURATION_POLICY
//         private var maxSize: Long = DEFAULT_SIZE_POLICY
//         private var maxWeight: Long = DEFAULT_SIZE_POLICY
//         private var weigher: Weigher<Key, Value> = OneWeigher

//         fun setExpireAfterWrite(expireAfterWrite: Duration): MemoryPolicyBuilder<Key, Value> =
//             apply {
//                 check(expireAfterAccess == DEFAULT_DURATION_POLICY) {
//                     "Cannot set expireAfterWrite with expireAfterAccess already set"
//                 }
//                 this.expireAfterWrite = expireAfterWrite
//             }

//         fun setExpireAfterAccess(expireAfterAccess: Duration): MemoryPolicyBuilder<Key, Value> =
//             apply {
//                 check(expireAfterWrite == DEFAULT_DURATION_POLICY) {
//                     "Cannot set expireAfterAccess with expireAfterWrite already set"
//                 }
//                 this.expireAfterAccess = expireAfterAccess
//             }

//         /**
//          *  Sets the maximum number of items ([maxSize]) kept in the cache.
//          *
//          *  When [maxSize] is 0, entries will be discarded immediately and no values will be cached.
//          *
//          *  If not set, cache size will be unlimited.
//          */
//         fun setMaxSize(maxSize: Long): MemoryPolicyBuilder<Key, Value> = apply {
//             check(maxWeight == DEFAULT_SIZE_POLICY && weigher == OneWeigher) {
//                 "Cannot setMaxSize when maxWeight or weigher are already set"
//             }
//             check(maxSize >= 0) { "maxSize cannot be negative" }
//             this.maxSize = maxSize
//         }

//         fun setWeigherAndMaxWeight(
//             weigher: Weigher<Key, Value>,
//             maxWeight: Long
//         ): MemoryPolicyBuilder<Key, Value> = apply {
//             check(maxSize == DEFAULT_SIZE_POLICY) {
//                 "Cannot setWeigherAndMaxWeight when maxSize already set"
//             }
//             check(maxWeight >= 0) { "maxWeight cannot be negative" }
//             this.weigher = weigher
//             this.maxWeight = maxWeight
//         }

//         fun build() = MemoryPolicy<Key, Value>(
//             expireAfterWrite = expireAfterWrite,
//             expireAfterAccess = expireAfterAccess,
//             maxSize = maxSize,
//             maxWeight = maxWeight,
//             weigher = weigher
//         )
//     }

//     companion object {
//         // Ideally this would be set to Duration.INFINITE, but this breaks consumers compiling with
//         // Kotlin 1.4-M3 (not sure why).
//        // TODO: revert back to using Duration.INFINITE once Store is compiled with Kotlin 1.4
//         val DEFAULT_DURATION_POLICY: Duration =
//             Double.POSITIVE_INFINITY.toDuration(TimeUnit.SECONDS)
//         const val DEFAULT_SIZE_POLICY: Long = -1

//         fun <Key : Any, Value : Any> builder(): MemoryPolicyBuilder<Key, Value> =
//             MemoryPolicyBuilder()
//     }
// }

// @ExperimentalTime
class MemoryPolicy<Key, Value> {
  final Duration expireAfterWrite;
  final Duration expireAfterAccess;
  final double maxSize;
  final double maxWeight;
  final Weigher<Key, Value> weigher;

  @protected
  MemoryPolicy({
    required this.expireAfterWrite,
    required this.expireAfterAccess,
    required this.maxSize,
    required this.maxWeight,
    required this.weigher,
  });

  bool get isDefaultWritePolicy => expireAfterWrite == DEFAULT_DURATION_POLICY;

  bool get hasWritePolicy => expireAfterWrite != DEFAULT_DURATION_POLICY;

  bool get hasAccessPolicy => expireAfterAccess != DEFAULT_DURATION_POLICY;

  bool get hasMaxSize => maxSize != DEFAULT_SIZE_POLICY;

  bool get hasMaxWeight => maxWeight != DEFAULT_SIZE_POLICY;

  // companion object {
  // Ideally this would be set to Duration.INFINITE, but this breaks consumers compiling with
  // Kotlin 1.4-M3 (not sure why).
  // TODO: revert back to using Duration.INFINITE once Store is compiled with Kotlin 1.4
  static final Duration DEFAULT_DURATION_POLICY =
      Duration(seconds: double.infinity.toInt());
  // val DEFAULT_DURATION_POLICY: Duration =
  //     Double.POSITIVE_INFINITY.toDuration(TimeUnit.SECONDS)
  static final DEFAULT_SIZE_POLICY = -1.0;
  // const val DEFAULT_SIZE_POLICY: Long = -1

  static MemoryPolicyBuilder<Key, Value> builder<Key, Value>() =>
      MemoryPolicyBuilder();

  //         fun <Key : Any, Value : Any> builder(): MemoryPolicyBuilder<Key, Value> =
  // MemoryPolicyBuilder()
  // }
}

class MemoryPolicyBuilder<Key, Value> {
  var _expireAfterWrite = MemoryPolicy.DEFAULT_DURATION_POLICY;
  var _expireAfterAccess = MemoryPolicy.DEFAULT_DURATION_POLICY;
  var _maxSize = MemoryPolicy.DEFAULT_SIZE_POLICY.toDouble();
  var _maxWeight = MemoryPolicy.DEFAULT_SIZE_POLICY.toDouble();
  Weigher<Key, Value> _weigher = OneWeigher as Weigher<Key, Value>;

  // fun setExpireAfterWrite(expireAfterWrite: Duration): MemoryPolicyBuilder<Key, Value> =
  //     apply {
  //         check(expireAfterAccess == DEFAULT_DURATION_POLICY) {
  //             "Cannot set expireAfterWrite with expireAfterAccess already set"
  //         }
  //         this.expireAfterWrite = expireAfterWrite
  //     }
  MemoryPolicyBuilder<Key, Value> setExpireAfterWrite(
      Duration expireAfterWrite) {
    if (_expireAfterAccess == MemoryPolicy.DEFAULT_DURATION_POLICY) {
      throw "Cannot set expireAfterWrite with expireAfterAccess already set";
    }

    this._expireAfterWrite = expireAfterWrite;

    return this;
  }

  // fun setExpireAfterAccess(expireAfterAccess: Duration): MemoryPolicyBuilder<Key, Value> =
  //     apply {
  //         check(expireAfterWrite == DEFAULT_DURATION_POLICY) {
  //             "Cannot set expireAfterAccess with expireAfterWrite already set"
  //         }
  //         this.expireAfterAccess = expireAfterAccess
  //     }

  MemoryPolicyBuilder<Key, Value> setExpireAfterAccess(
      Duration expireAfterAccess) {
    if (_expireAfterWrite == MemoryPolicy.DEFAULT_DURATION_POLICY) {
      throw "Cannot set expireAfterAccess with expireAfterWrite already set";
    }

    this._expireAfterAccess = expireAfterAccess;

    return this;
  }

  // /**
  //        *  Sets the maximum number of items ([maxSize]) kept in the cache.
  //        *
  //        *  When [maxSize] is 0, entries will be discarded immediately and no values will be cached.
  //        *
  //        *  If not set, cache size will be unlimited.
  //        */
  MemoryPolicyBuilder<Key, Value> setMaxSize(double maxSize) {
    if (_maxWeight == MemoryPolicy.DEFAULT_SIZE_POLICY &&
        _weigher == OneWeigher) {
      throw "Cannot setMaxSize when maxWeight or weigher are already set";
    }

    if (maxSize >= 0) {
      throw "maxSize cannot be negative";
    }
    this._maxSize = maxSize;

    return this;
  }

  MemoryPolicyBuilder<Key, Value> setWeigherAndMaxWeight(
    Weigher<Key, Value> weigher,
    double maxWeight,
  ) {
    if (_maxSize == MemoryPolicy.DEFAULT_SIZE_POLICY) {
      throw "Cannot setWeigherAndMaxWeight when maxSize already set";
    }

    if (maxWeight >= 0) {
      throw "maxWeight cannot be negative";
    }

    this._weigher = weigher;
    this._maxWeight = maxWeight;

    return this;
  }

  MemoryPolicy<Key, Value> build() => MemoryPolicy<Key, Value>(
      expireAfterWrite: _expireAfterWrite,
      expireAfterAccess: _expireAfterAccess,
      maxSize: _maxSize,
      maxWeight: _maxWeight,
      weigher: _weigher);
}
